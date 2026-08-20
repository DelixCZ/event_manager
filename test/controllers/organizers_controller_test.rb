require "test_helper"

class OrganizersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organizer = organizers(:maya)
  end

  test "should get index" do
    get organizers_url
    assert_response :success
    assert_select "h1", "Organizers"
    assert_select "a", text: "New Organizer"
  end

  test "should get show" do
    get organizer_url(@organizer)
    assert_response :success
    assert_select "h1", @organizer.name
  end

  test "should get new" do
    get new_organizer_url
    assert_response :success
  end

  test "should create organizer" do
    assert_difference("Organizer.count") do
      post organizers_url, params: {
        organizer: { name: "Amina Diallo", email: "amina.diallo@example.com" }
      }
    end

    assert_redirected_to organizer_url(Organizer.last)
  end

  test "should not create organizer with a duplicate email" do
    assert_no_difference("Organizer.count") do
      post organizers_url, params: {
        organizer: { name: "Duplicate", email: @organizer.email }
      }
    end

    assert_response :unprocessable_content
  end

  test "should get edit" do
    get edit_organizer_url(@organizer)
    assert_response :success
  end

  test "should update organizer" do
    patch organizer_url(@organizer), params: { organizer: { name: "Maya Chen Updated" } }
    assert_redirected_to organizer_url(@organizer)
    @organizer.reload
    assert_equal "Maya Chen Updated", @organizer.name
  end

  test "should destroy organizer and their events" do
    assert_difference("Event.count", -1) do
      assert_difference("Organizer.count", -1) do
        delete organizer_url(@organizer)
      end
    end

    assert_redirected_to organizers_url
  end
end
