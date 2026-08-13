require "test_helper"

class OrganizerTest < ActiveSupport::TestCase
  test "valid organizer" do
    organizer = Organizer.new(name: "Amina Diallo", email: "amina@example.com")
    assert organizer.valid?
  end

  test "requires name and email" do
    organizer = Organizer.new
    assert_not organizer.valid?
    assert_includes organizer.errors[:name], "can't be blank"
    assert_includes organizer.errors[:email], "can't be blank"
  end

  test "requires a unique email" do
    organizer = Organizer.new(name: "Duplicate", email: organizers(:maya).email)
    assert_not organizer.valid?
    assert_includes organizer.errors[:email], "has already been taken"
  end

  test "rejects an invalid email format" do
    organizer = Organizer.new(name: "Amina Diallo", email: "not-an-email")
    assert_not organizer.valid?
    assert_includes organizer.errors[:email], "is invalid"
  end
end
