class Attendee < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :events, through: :enrollments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
