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

  test "shows three gold stars for a completed mission" do
    user = User.create!(display_name: "Ada", email_address: "ada@example.test", password: "password123")
    mission = Mission.create!(number: 1, slug: "qubit-basics", title: "Qubit Basics", summary: "Learn qubits",
                              xp_reward: 100, badge_name: "Qubit Explorer", status: "playable")
    MissionCompletion.create!(user: user, mission: mission, xp_awarded: 100, completed_at: Time.current)
    sign_in_as(user)

    get root_path

    assert_response :success
    assert_select "p[aria-label='Three correct quiz answers']", "★★★"
  end
end
