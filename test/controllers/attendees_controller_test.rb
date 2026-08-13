require "test_helper"

class AttendeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:summit)
  end

  test "should create attendee" do
    assert_difference("Attendee.count") do
      post event_attendees_url(@event), params: {
        attendee: { name: "Hana Kim", email: "hana.kim@example.com" }
      }
    end

    assert_redirected_to event_url(@event)
  end

  test "should not create attendee without a name" do
    assert_no_difference("Attendee.count") do
      post event_attendees_url(@event), params: {
        attendee: { name: "", email: "hana.kim@example.com" }
      }
    end

    assert_response :unprocessable_content
  end

  test "should destroy attendee" do
    attendee = attendees(:elena)

    assert_difference("Attendee.count", -1) do
      delete event_attendee_url(@event, attendee)
    end

    assert_redirected_to event_url(@event)
  end
end
