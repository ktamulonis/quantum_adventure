require "test_helper"

class MissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(display_name: "Ada", email_address: "ada@example.test", password: "password123")
    @qubit = Mission.create!(number: 1, slug: "qubit-basics", title: "Qubit Basics", summary: "Learn qubits",
                             xp_reward: 100, badge_name: "Qubit Explorer", status: "playable")
    @superposition = Mission.create!(number: 2, slug: "superposition", title: "Superposition", summary: "Learn H",
                                     xp_reward: 150, badge_name: "Superposition Master", prerequisite_number: 1,
                                     status: "playable")
    3.times do |index|
      QuizQuestion.create!(mission: @qubit, prompt: "Question #{index}", options: [ "A", "B" ], correct_option: 0,
                           explanation: "Because")
    end
    sign_in_as(@user)
  end

  test "renders the first mission experiment" do
    get mission_path(@qubit)

    assert_response :success
    assert_select "h1", "Qubit Basics"
    assert_select "h3", "Measure in Z"
    assert_select "[data-controller='qbit-chat']"
    assert_select "img[src='/images/qbit.png'][alt*='Q-Bit']"
    assert_select "p", /Prepare \|0⟩ to reveal this explanation/
  end

  test "unlocks a plain-language clue for each prepared qubit state" do
    get mission_path(@qubit), params: { preset: "one" }

    assert_response :success
    assert_select "h3", "The X gate is the quantum bit flip"
    assert_select "p", /Z measurement returns 1 with certainty/

    get mission_path(@qubit), params: { preset: "plus" }

    assert_response :success
    assert_select "h3", "A qubit can be predictable in one basis and random in another"
    assert_select "p", /not a classical coin flip/
  end

  test "returns a Q-Bit answer for the current mission as JSON" do
    with_qbit_reply("Prepare |1⟩ applies X to |0⟩.") do
      post qbit_chat_mission_path(@qubit), params: {
        message: "What does Prepare |1⟩ do?",
        history: [ { role: "user", content: "hello" } ]
      }, as: :json
    end

    assert_response :success
    assert_equal "Prepare |1⟩ applies X to |0⟩.", response.parsed_body.fetch("reply")
    assert_equal "llama3.2:latest", response.parsed_body.fetch("model")
  end

  private

  def with_qbit_reply(reply)
    singleton_class = QbitTutor.singleton_class
    original_reply = singleton_class.instance_method(:reply)
    singleton_class.define_method(:reply) { |**| reply }
    yield
  ensure
    singleton_class.define_method(:reply, original_reply)
  end

  test "prevents direct access to a locked mission" do
    get mission_path(@superposition)

    assert_redirected_to missions_path
  end

  test "submits a quiz and unlocks the next mission" do
    answers = @qubit.quiz_questions.to_h { |question| [ question.id.to_s, "0" ] }

    post submit_quiz_mission_path(@qubit), params: { answers: answers }

    assert_redirected_to root_path
    assert @superposition.unlocked_for?(@user)
  end

  test "renders unlocked entanglement and Bell test experiments" do
    entanglement = Mission.create!(number: 3, slug: "entanglement", title: "Entanglement", summary: "Bell pairs",
                                   xp_reward: 200, badge_name: "Entangler", prerequisite_number: 2, status: "playable")
    bell_test = Mission.create!(number: 4, slug: "bell-test", title: "Bell Test", summary: "CHSH", xp_reward: 200,
                                badge_name: "Bell Winner", prerequisite_number: 3, status: "playable")
    MissionCompletion.create!(user: @user, mission: @qubit, xp_awarded: 100, completed_at: Time.current)
    MissionCompletion.create!(user: @user, mission: @superposition, xp_awarded: 150, completed_at: Time.current)
    MissionCompletion.create!(user: @user, mission: entanglement, xp_awarded: 200, completed_at: Time.current)

    get mission_path(entanglement), params: { shots: 100 }
    assert_response :success
    assert_select "h1", "Entanglement"
    get mission_path(bell_test), params: { shots: 500 }
    assert_response :success
    assert_select "h1", "Bell Test"
  end
end
