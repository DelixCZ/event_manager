ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def create_capacity_event(capacity)
      Event.create!(
        title: "Capacity #{capacity} #{SecureRandom.hex(4)}",
        start_date: Date.new(2026, 8, 21),
        end_date: Date.new(2026, 8, 23),
        organizer: organizers(:maya),
        capacity: capacity
      )
    end

    def enroll_person(event, label)
      attendee = Attendee.create!(name: label.titleize, email: "#{label}-#{SecureRandom.hex(4)}@example.com")
      event.enrollments.create!(attendee: attendee)
    end
  end
end
