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

  test "shows the latest partial quiz stars and a continue link" do
    user = User.create!(display_name: "Ada", email_address: "ada@example.test", password: "password123")
    mission = Mission.create!(number: 1, slug: "qubit-basics", title: "Qubit Basics", summary: "Learn qubits",
                              xp_reward: 100, badge_name: "Qubit Explorer", status: "playable")
    QuizAttempt.create!(user: user, mission: mission, answers: { "1" => "0" }, correct_count: 2,
                        question_count: 3, passed: false)
    sign_in_as(user)

    get root_path

    assert_response :success
    assert_select "#mission-qubit-basics p[aria-label='2 correct out of 3 quiz answers']", "★★☆"
    assert_select "#mission-qubit-basics a[href='/missions/qubit-basics/quiz']", "Continue quiz"
  end

  test "launches Mission 6 in the roadmap after Mission 5 completion" do
    user = User.create!(display_name: "Ada", email_address: "ada@example.test", password: "password123")
    teleportation = Mission.create!(number: 5, slug: "teleportation", title: "Quantum Teleportation",
                                    summary: "Transfer a state", xp_reward: 250, badge_name: "Teleporter",
                                    prerequisite_number: 4, status: "playable")
    interference = Mission.create!(number: 6, slug: "interference", title: "Interference",
                                   summary: "Add and cancel amplitudes", xp_reward: 150,
                                   badge_name: "Interference Insider", prerequisite_number: 5, status: "playable")
    coming_soon = Mission.create!(number: 7, slug: "grovers-search", title: "Grover’s Search",
                                  summary: "Find a marked state", xp_reward: 300, badge_name: "Grover Guide",
                                  prerequisite_number: 6, status: "coming_soon")
    sign_in_as(user)

    get root_path
    assert_select "#mission-interference" do
      assert_select "p", "Locked"
      assert_select "a", count: 0
    end
    assert_select "#mission-grovers-search p", "Locked / coming soon"

    MissionCompletion.create!(user: user, mission: teleportation, xp_awarded: 250, completed_at: Time.current)
    get root_path
    assert_select "#mission-interference" do
      assert_select "p", "Ready"
      assert_select "a[href='/missions/interference'][class*='rounded-full'][class*='bg-emerald-700'][class*='hover:bg-white'][class*='active:scale-95']", "Start mission"
    end

    MissionCompletion.create!(user: user, mission: interference, xp_awarded: 150, completed_at: Time.current)
    get root_path
    assert_select "#mission-interference" do
      assert_select "p", "Completed"
      assert_select "p[aria-label='Three correct quiz answers']", "★★★"
    end
  end
end
