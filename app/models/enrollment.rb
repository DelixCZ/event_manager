class Enrollment < ApplicationRecord
  belongs_to :event
  belongs_to :attendee

  attribute :status, :string
  enum :status, { confirmed: "confirmed", waitlisted: "waitlisted" }, default: :confirmed, validate: true

  validates :attendee_id, uniqueness: { scope: :event_id }

  scope :in_waitlist_order, -> { order(:waitlisted_at, :id) }

  before_validation :assign_status_from_capacity, on: :create
  before_save :sync_waitlisted_at
  after_destroy :promote_waitlist_if_confirmed_seat_freed
  after_update :promote_waitlist_if_confirmed_seat_freed

  private

  def assign_status_from_capacity
    self.status = event&.has_available_seat? ? :confirmed : :waitlisted
  end

  def sync_waitlisted_at
    if confirmed?
      self.waitlisted_at = nil
    elsif waitlisted? && waitlisted_at.blank?
      self.waitlisted_at = Time.current
    end
  end

  def promote_waitlist_if_confirmed_seat_freed
    return if destroyed_by_association
    return unless event&.persisted?
    return unless confirmed_seat_freed?

    event.promote_from_waitlist!
  end

  def confirmed_seat_freed?
    if destroyed?
      confirmed?
    else
      saved_change_to_status? && status_previously_was == "confirmed" && waitlisted?
    end
  end
end
