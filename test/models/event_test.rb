require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "valid event" do
    event = Event.new(
      title: "Winter Demo Night",
      start_date: Date.new(2026, 12, 4),
      end_date: Date.new(2026, 12, 5),
      organizer: organizers(:maya)
    )
    assert event.valid?
  end

  test "requires title, start_date, end_date, and organizer" do
    event = Event.new
    assert_not event.valid?
    assert_includes event.errors[:title], "can't be blank"
    assert_includes event.errors[:start_date], "can't be blank"
    assert_includes event.errors[:end_date], "can't be blank"
    assert_includes event.errors[:organizer], "must exist"
  end

  test "end_date must be after start_date" do
    event = events(:summit)
    event.end_date = event.start_date
    assert_not event.valid?
    assert_includes event.errors[:end_date], "must be after start date"

    event.end_date = event.start_date - 1.day
    assert_not event.valid?
    assert_includes event.errors[:end_date], "must be after start date"
  end

  test "skips the date order check when a date is missing" do
    event = Event.new(title: "Incomplete", start_date: Date.today, organizer: organizers(:maya))
    event.valid?
    assert_not_includes event.errors[:end_date], "must be after start date"
  end
end
