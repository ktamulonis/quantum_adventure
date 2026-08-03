require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "requires authentication" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "shows private progress to an authenticated explorer" do
    user = User.create!(display_name: "Ada", email_address: "ada@example.test", password: "password123")
    sign_in_as(user)

    get root_path

    assert_response :success
    assert_select "h1", "Quantum Adventure"
    assert_select "p", /Ada/
  end
end
