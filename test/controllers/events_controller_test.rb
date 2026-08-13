require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:summit)
  end

  test "should get index" do
    get events_url
    assert_response :success
    assert_select "h1", "Events"
  end

  test "should get show" do
    get event_url(@event)
    assert_response :success
    assert_select "h1", @event.title
    assert_select "h2", /Attendees/
    assert_select "form"
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: {
        event: {
          title: "Design Systems Intensive",
          description: "Tokens and documentation.",
          location: "Stockholm",
          start_date: "2026-11-09",
          end_date: "2026-11-11",
          organizer_id: organizers(:maya).id
        }
      }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should not create event with end_date on start_date" do
    assert_no_difference("Event.count") do
      post events_url, params: {
        event: {
          title: "Same-day event",
          start_date: "2026-11-09",
          end_date: "2026-11-09",
          organizer_id: organizers(:maya).id
        }
      }
    end

    assert_response :unprocessable_content
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { title: "Updated Summit" } }
    assert_redirected_to event_url(@event)
    @event.reload
    assert_equal "Updated Summit", @event.title
  end

  test "should destroy event" do
    assert_difference("Attendee.count", -2) do
      assert_difference("Event.count", -1) do
        delete event_url(@event)
      end
    end

    assert_redirected_to events_url
  end
end
