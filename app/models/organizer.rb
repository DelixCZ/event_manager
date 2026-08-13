class Organizer < ApplicationRecord
  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
