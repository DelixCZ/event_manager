require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  test "valid enrollment" do
    enrollment = Enrollment.new(event: events(:workshop), attendee: attendees(:elena))
    assert enrollment.valid?
  end

  test "belongs to an event and an attendee" do
    enrollment = Enrollment.new
    assert_not enrollment.valid?
    assert_includes enrollment.errors[:event], "must exist"
    assert_includes enrollment.errors[:attendee], "must exist"
  end

  test "prevents registering the same attendee for the same event twice" do
    duplicate = Enrollment.new(event: events(:summit), attendee: attendees(:elena))
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:attendee_id], "has already been taken"
  end

  test "normal registration within capacity sets status to confirmed" do
    event = create_capacity_event(2)
    enrollment = enroll_person(event, "within-capacity")

    assert enrollment.confirmed?
    assert_equal "confirmed", enrollment.status
  end

  test "exceeding capacity automatically sets status to waitlisted" do
    event = create_capacity_event(1)
    confirmed = enroll_person(event, "takes-seat")
    waitlisted = enroll_person(event, "goes-to-waitlist")

    assert confirmed.confirmed?
    assert waitlisted.waitlisted?
    assert_equal "waitlisted", waitlisted.status
  end

  test "canceling a confirmed registration promotes the first person on the waitlist" do
    event = create_capacity_event(1)
    confirmed = enroll_person(event, "leaving")
    waitlisted = enroll_person(event, "promoted")

    confirmed.destroy

    assert waitlisted.reload.confirmed?
    assert_equal 1, event.enrollments.confirmed.count
    assert_equal 0, event.enrollments.waitlisted.count
  end

  test "waitlist promotion is FIFO" do
    event = create_capacity_event(1)
    confirmed = enroll_person(event, "seat-holder")
    first_waitlisted = enroll_person(event, "first-in-line")
    second_waitlisted = enroll_person(event, "second-in-line")

    first_waitlisted.update_columns(waitlisted_at: 2.minutes.ago)
    second_waitlisted.update_columns(waitlisted_at: 1.minute.ago)

    confirmed.destroy

    assert first_waitlisted.reload.confirmed?
    assert second_waitlisted.reload.waitlisted?
  end
end
