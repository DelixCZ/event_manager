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

  test "exposes attendees through enrollments" do
    event = events(:summit)
    assert_includes event.attendees, attendees(:elena)
    assert_includes event.attendees, attendees(:tomas)
  end

  test "skips the date order check when a date is missing" do
    event = Event.new(title: "Incomplete", start_date: Date.today, organizer: organizers(:maya))
    event.valid?
    assert_not_includes event.errors[:end_date], "must be after start date"
  end

  test "increasing capacity automatically promotes eligible waitlisted attendees" do
    event = create_capacity_event(1)
    confirmed = enroll_person(event, "confirmed")
    first_waitlisted = enroll_person(event, "wait-one")
    second_waitlisted = enroll_person(event, "wait-two")

    assert confirmed.confirmed?
    assert first_waitlisted.waitlisted?
    assert second_waitlisted.waitlisted?

    event.update!(capacity: 2)

    assert confirmed.reload.confirmed?
    assert first_waitlisted.reload.confirmed?
    assert second_waitlisted.reload.waitlisted?
  end

  test "decreasing capacity waitlists the most recent confirmed attendees" do
    event = create_capacity_event(3)
    first = enroll_person(event, "keep-one")
    second = enroll_person(event, "kick-two")
    third = enroll_person(event, "kick-three")

    first.update_columns(created_at: 3.minutes.ago)
    second.update_columns(created_at: 2.minutes.ago)
    third.update_columns(created_at: 1.minute.ago)

    event.update!(capacity: 1)

    assert first.reload.confirmed?
    assert second.reload.waitlisted?
    assert third.reload.waitlisted?
    assert_equal [ second.id, third.id ], event.enrollments.waitlisted.in_waitlist_order.pluck(:id)

    overflow = enroll_person(event, "overflow")
    assert overflow.waitlisted?
    assert_equal [ second.id, third.id, overflow.id ], event.enrollments.waitlisted.in_waitlist_order.pluck(:id)
    assert_equal 0, event.reload.seats_remaining
  end

  test "a demoted attendee is placed first on the waitlist" do
    event = create_capacity_event(2)
    keeper = enroll_person(event, "keeper")
    latest = enroll_person(event, "latest")
    already_waiting = enroll_person(event, "already-waiting")

    keeper.update_columns(created_at: 3.minutes.ago)
    latest.update_columns(created_at: 2.minutes.ago)
    already_waiting.update_columns(created_at: 1.minute.ago, waitlisted_at: 1.minute.ago)

    event.update!(capacity: 1)

    assert keeper.reload.confirmed?
    assert_equal [ latest.id, already_waiting.id ], event.enrollments.waitlisted.in_waitlist_order.pluck(:id)
  end
end
