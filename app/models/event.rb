class Event < ApplicationRecord
  belongs_to :organizer
  has_many :enrollments, dependent: :destroy
  has_many :attendees, through: :enrollments

  attribute :capacity, :integer, default: 10

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validate :end_date_after_start_date

  after_update :sync_waitlist_with_capacity

  def confirmed_count
    if enrollments.loaded?
      enrollments.count { |enrollment| enrollment.persisted? && enrollment.confirmed? }
    else
      enrollments.confirmed.count
    end
  end

  def waitlisted_count
    if enrollments.loaded?
      enrollments.count { |enrollment| enrollment.persisted? && enrollment.waitlisted? }
    else
      enrollments.waitlisted.count
    end
  end

  def seats_remaining
    [ capacity - confirmed_count, 0 ].max
  end

  def has_available_seat?
    confirmed_count < capacity
  end

  def full?
    !has_available_seat?
  end

  def promote_from_waitlist!
    spots = seats_remaining
    return if spots.zero?

    enrollments.waitlisted.in_waitlist_order.limit(spots).each do |enrollment|
      enrollment.update!(status: :confirmed)
    end
  end

  def demote_overflow_to_waitlist!
    overflow = confirmed_count - capacity
    return if overflow <= 0

    to_demote = enrollments.confirmed.order(created_at: :desc, id: :desc).limit(overflow).to_a
    base_time = enrollments.waitlisted.minimum(:waitlisted_at) || Time.current

    # Keep original signup order among people bumped in the same decrease
    # (earlier enrollment = higher waitlist). Place the whole group in front
    # of anyone who was already waiting.
    to_demote.reverse.each_with_index do |enrollment, index|
      enrollment.update!(
        status: :waitlisted,
        waitlisted_at: base_time - (to_demote.size - index).seconds
      )
    end
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  def sync_waitlist_with_capacity
    return unless saved_change_to_capacity?

    previous_capacity, new_capacity = saved_change_to_capacity
    return if previous_capacity.blank? || new_capacity.blank? || previous_capacity == new_capacity

    if new_capacity > previous_capacity
      promote_from_waitlist!
    else
      demote_overflow_to_waitlist!
    end
  end
end
