class Event < ApplicationRecord
  belongs_to :organizer
  has_many :attendees, dependent: :destroy

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end
end
