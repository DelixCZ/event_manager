require "test_helper"

class EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:summit)
  end

  test "should create an attendee and enroll them" do
    assert_difference("Attendee.count") do
      assert_difference("Enrollment.count") do
        post event_enrollments_url(@event), params: {
          attendee: { name: "Hana Kim", email: "hana.kim@example.com" }
        }
      end
    end

    assert_redirected_to event_url(@event)
    assert_equal "Attendee was successfully added.", flash[:notice]
  end

  test "should enroll an existing attendee without duplicating them" do
    attendee = attendees(:elena)

    assert_no_difference("Attendee.count") do
      assert_difference("Enrollment.count") do
        post event_enrollments_url(events(:workshop)), params: {
          attendee: { name: attendee.name, email: attendee.email }
        }
      end
    end

    assert_redirected_to event_url(events(:workshop))
    assert_includes events(:workshop).reload.attendees, attendee
  end

  test "should not enroll the same attendee twice" do
    attendee = attendees(:elena)

    assert_no_difference([ "Attendee.count", "Enrollment.count" ]) do
      post event_enrollments_url(@event), params: {
        attendee: { name: attendee.name, email: attendee.email }
      }
    end

    assert_redirected_to event_url(@event)
    assert_equal "This attendee is already registered for this event.", flash[:alert]
  end

  test "should not create attendee without a name" do
    assert_no_difference([ "Attendee.count", "Enrollment.count" ]) do
      post event_enrollments_url(@event), params: {
        attendee: { name: "", email: "hana.kim@example.com" }
      }
    end

    assert_response :unprocessable_content
  end

  test "should unenroll an attendee without deleting them" do
    enrollment = enrollments(:summit_elena)

    assert_difference("Enrollment.count", -1) do
      assert_no_difference("Attendee.count") do
        delete event_enrollment_url(@event, enrollment)
      end
    end

    assert_redirected_to event_url(@event)
  end
end
