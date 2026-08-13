require "test_helper"

class AttendeeTest < ActiveSupport::TestCase
  test "valid attendee" do
    attendee = Attendee.new(name: "Priya Shah", email: "priya@example.com", event: events(:summit))
    assert attendee.valid?
  end

  test "requires name, email, and event" do
    attendee = Attendee.new
    assert_not attendee.valid?
    assert_includes attendee.errors[:name], "can't be blank"
    assert_includes attendee.errors[:email], "can't be blank"
    assert_includes attendee.errors[:event], "must exist"
  end

  test "rejects an invalid email format" do
    attendee = Attendee.new(name: "Priya Shah", email: "priya@", event: events(:summit))
    assert_not attendee.valid?
    assert_includes attendee.errors[:email], "is invalid"
  end
end
