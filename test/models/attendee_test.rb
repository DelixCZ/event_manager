require "test_helper"

class AttendeeTest < ActiveSupport::TestCase
  test "valid attendee" do
    attendee = Attendee.new(name: "Priya Shah", email: "priya@example.com")
    assert attendee.valid?
  end

  test "requires name and email" do
    attendee = Attendee.new
    assert_not attendee.valid?
    assert_includes attendee.errors[:name], "can't be blank"
    assert_includes attendee.errors[:email], "can't be blank"
  end

  test "requires a unique email" do
    attendee = Attendee.new(name: "Duplicate", email: attendees(:elena).email)
    assert_not attendee.valid?
    assert_includes attendee.errors[:email], "has already been taken"
  end

  test "rejects an invalid email format" do
    attendee = Attendee.new(name: "Priya Shah", email: "priya@")
    assert_not attendee.valid?
    assert_includes attendee.errors[:email], "is invalid"
  end
end
