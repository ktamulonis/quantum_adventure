require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "renders the welcome registration screen" do
    get new_registration_path

    assert_response :success
    assert_select "h1", "Join Quantum Adventure"
    assert_select "form[action='#{registration_path}'][method='post']"
    assert_select "img[src='/images/dr-q-welcome.png'][alt*='Dr. Q']"
    assert_select "p", /Welcome, explorer!/
  end

  test "creates an explorer through the singular registration route" do
    assert_difference("User.count") do
      post registration_path, params: {
        user: {
          display_name: "New Explorer",
          email_address: "explorer@example.test",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end
end
