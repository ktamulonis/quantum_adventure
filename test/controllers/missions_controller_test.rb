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
    assert_select "img[src='/images/mission-qubit-basics.png'][alt*='Bloch sphere']"
    assert_select "h3", "Measure in Z"
    assert_select "[data-controller='qbit-chat']"
    assert_select "img[src='/images/qbit.png'][alt*='Q-Bit']"
    assert_select "[data-clue-key='zero'] p", "Locked clue"
    assert_select "turbo-frame#qubit-basics-experiment"
    assert_select "a[data-turbo-frame='qubit-basics-experiment']", QubitBasicsLesson::PRESETS.length
  end

  test "unlocks Qubit Basics clues one prepared state at a time" do
    get mission_path(@qubit), params: { preset: "zero" }

    assert_response :success
    assert_select "[data-clue-key='zero'] h3", "A measurement has probabilities, not hidden answers"
    assert_select "[data-clue-key='one'] p", "Locked clue"
    assert_select "[data-clue-key='plus'] p", "Locked clue"

    get mission_path(@qubit), params: { preset: "one" }

    assert_response :success
    assert_select "[data-clue-key='zero'] h3", "A measurement has probabilities, not hidden answers"
    assert_select "h3", "The X gate is the quantum bit flip"
    assert_select "p", /Z measurement returns 1 with certainty/
    assert_select "[data-clue-key='plus'] p", "Locked clue"

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
    qbit_singleton_class = QbitTutor.singleton_class
    original_reply = qbit_singleton_class.instance_method(:reply)
    qbit_singleton_class.define_method(:reply) { |**| reply }
    yield
  ensure
    qbit_singleton_class&.define_method(:reply, original_reply) if original_reply
  end

  test "prevents direct access to a locked mission" do
    get mission_path(@superposition)

    assert_redirected_to missions_path
  end

  test "renders the Superposition mission artwork after Mission 1 is complete" do
    MissionCompletion.create!(user: @user, mission: @qubit, xp_awarded: 100, completed_at: Time.current)

    get mission_path(@superposition)

    assert_response :success
    assert_select "h1", "Superposition"
    assert_select "img[src='/images/mission-superposition.png'][alt*='plus superposition']"
    assert_select "turbo-frame#superposition-experiment"
    assert_select "a[data-turbo-frame='superposition-experiment']", SuperpositionLesson::PRESETS.length
    assert_select "[aria-label='History of this mission']", /Superposition comes from the wave rule/

    get mission_path(@superposition), params: { preset: "plus" }
    assert_select "[data-clue-key='plus'] h3", "H prepares an X-basis state"
  end

  test "shows per-question stars and requires every correct answer to unlock the next mission" do
    incorrect_answers = @qubit.quiz_questions.each_with_index.to_h do |question, index|
      [ question.id.to_s, index.zero? ? "1" : "0" ]
    end

    post submit_quiz_mission_path(@qubit), params: { answers: incorrect_answers }

    assert_response :unprocessable_content
    assert_select "[aria-label='Quiz feedback']"
    assert_select "fieldset", 3
    assert_select "span", "★"
    assert_select "span", "☆"
    refute @superposition.unlocked_for?(@user)

    answers = @qubit.quiz_questions.to_h { |question| [ question.id.to_s, "0" ] }

    post submit_quiz_mission_path(@qubit), params: { answers: answers }

    assert_response :success
    assert_select "[aria-label='Mission complete']"
    assert_select "p", /All 3 answers are correct/
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
    assert_select "img[src='/images/mission-entanglement.png'][alt='Illustration of two entangled qubits']"
    assert_select "turbo-frame#entanglement-experiment"
    assert_select "form[data-turbo-frame='entanglement-experiment']"
    assert_select "[aria-label='History of this mission']", /Entanglement was named in a 1935 argument/
    get mission_path(bell_test), params: { shots: 500 }
    assert_response :success
    assert_select "h1", "Bell Test"
    assert_select "img[src='/images/mission-bell-test.png'][alt='Illustration of a Bell test between two measurement stations']"
    assert_select "turbo-frame#bell-test-experiment"
    assert_select "form[data-turbo-frame='bell-test-experiment']"
    assert_select "[aria-label='History of this mission']", /Bell turned a philosophical dispute into a test/
  end

  test "renders the unlocked teleportation walkthrough with Q-Bit and the protocol stages" do
    entanglement = create_playable_mission(3, "entanglement", 2)
    bell_test = create_playable_mission(4, "bell-test", 3)
    teleportation = create_playable_mission(5, "teleportation", 4)
    [ @qubit, @superposition, entanglement, bell_test ].each_with_index do |mission, index|
      MissionCompletion.create!(user: @user, mission: mission, xp_awarded: 100, completed_at: Time.current + index)
    end

    get mission_path(teleportation), params: { input: "plus", seed: 42, stage: "classical_bits_sent" }

    assert_response :success
    assert_select "h1", "Quantum Teleportation"
    assert_select "[aria-label='Teleportation protocol visualizer']"
    assert_select "p", /Classical channel/
    assert_select "[data-controller=qbit-chat]"
    assert_select "turbo-frame#teleportation-experiment"
    assert_select "a[data-turbo-frame='teleportation-experiment']", TeleportationLesson::INPUTS.length + 2
    assert_select "a[href*='stage=bob_corrects']", "Next step →"
    assert_select "[aria-label='History of this mission']", /Teleportation was proposed as state transfer/
  end

  test "renders the unlocked interference simulator with Turbo controls and state snapshots" do
    entanglement = create_playable_mission(3, "entanglement", 2)
    bell_test = create_playable_mission(4, "bell-test", 3)
    teleportation = create_playable_mission(5, "teleportation", 4)
    interference = create_playable_mission(6, "interference", 5)
    [ @qubit, @superposition, entanglement, bell_test, teleportation ].each_with_index do |mission, index|
      MissionCompletion.create!(user: @user, mission: mission, xp_awarded: 100, completed_at: Time.current + index)
    end

    get mission_path(interference), params: { preset: "cancel_zero" }

    assert_response :success
    assert_select "h1", "Interference"
    assert_select "img[src='/images/mission-interference.png'][alt*='interfering quantum']"
    assert_select "turbo-frame#interference-experiment"
    assert_select "[aria-label='Interference simulator']"
    assert_select "a[data-turbo-frame='interference-experiment']", InterferenceLesson::PRESETS.length
    assert_select "p", /cancel at \|0⟩/
    assert_select "[data-controller=qbit-chat]"
    assert_select "[aria-label='History of this mission']", /Quantum computing borrows a lesson from waves/
    assert_select "[data-clue-key='cancel_zero'] h3", "A phase flip redirects the outcome"
  end

  test "renders the unlocked Grover search experiment with Turbo marked-state controls" do
    entanglement = create_playable_mission(3, "entanglement", 2)
    bell_test = create_playable_mission(4, "bell-test", 3)
    teleportation = create_playable_mission(5, "teleportation", 4)
    interference = create_playable_mission(6, "interference", 5)
    grovers_search = create_playable_mission(7, "grovers-search", 6)
    [ @qubit, @superposition, entanglement, bell_test, teleportation, interference ].each_with_index do |mission, index|
      MissionCompletion.create!(user: @user, mission: mission, xp_awarded: 100, completed_at: Time.current + index)
    end

    get mission_path(grovers_search), params: { marked_state: "10", seed: 42 }

    assert_response :success
    assert_select "h1", "Grover’s Search"
    assert_select "img[src='/images/mission-grovers-search.png'][alt*='marked item']"
    assert_select "turbo-frame#grovers-search-experiment"
    assert_select "[aria-label='Grover search simulator']"
    assert_select "a[data-turbo-frame='grovers-search-experiment']", GroversSearchLesson::MARKED_STATES.length
    assert_select "[data-stage='oracle']", /phase oracle/
    assert_select "[aria-label='Grover measurement result']", /\|10⟩/
    assert_select "[data-controller=qbit-chat]"
    assert_select "[aria-label='History of this mission']", /Lov Grover found a search rule based on phase/
    assert_select "[data-clue-key='10'] h3", "Diffusion turns phase into probability"
  end

  test "renders the unlocked noise and hardware comparison with Turbo controls" do
    entanglement = create_playable_mission(3, "entanglement", 2)
    bell_test = create_playable_mission(4, "bell-test", 3)
    teleportation = create_playable_mission(5, "teleportation", 4)
    interference = create_playable_mission(6, "interference", 5)
    grovers_search = create_playable_mission(7, "grovers-search", 6)
    noise_hardware = create_playable_mission(8, "noise-hardware", 7)
    [ @qubit, @superposition, entanglement, bell_test, teleportation, interference, grovers_search ].each_with_index do |mission, index|
      MissionCompletion.create!(user: @user, mission: mission, xp_awarded: 100, completed_at: Time.current + index)
    end

    get mission_path(noise_hardware), params: { preset: "phase_flip", seed: 42 }

    assert_response :success
    assert_select "h1", "Noise & Real Hardware"
    assert_select "turbo-frame#noise-hardware-experiment"
    assert_select "[aria-label='Noise and hardware simulator']"
    assert_select "a[data-turbo-frame='noise-hardware-experiment']", NoiseHardwareLesson::PRESETS.length
    assert_select "[aria-label='Ideal and noisy measurement comparison']"
    assert_select "p", /small X\/Z channel is intentionally narrower/
    assert_select "[data-clue-key='phase_flip'] h3", "A phase flip can spoil a later interference test"
    assert_select "[data-controller=qbit-chat]"
  end

  test "renders the unlocked error correction trace with Turbo controls" do
    entanglement = create_playable_mission(3, "entanglement", 2)
    bell_test = create_playable_mission(4, "bell-test", 3)
    teleportation = create_playable_mission(5, "teleportation", 4)
    interference = create_playable_mission(6, "interference", 5)
    grovers_search = create_playable_mission(7, "grovers-search", 6)
    noise_hardware = create_playable_mission(8, "noise-hardware", 7)
    error_correction = create_playable_mission(9, "error-correction", 8)
    [ @qubit, @superposition, entanglement, bell_test, teleportation, interference, grovers_search, noise_hardware ].each_with_index do |mission, index|
      MissionCompletion.create!(user: @user, mission: mission, xp_awarded: 100, completed_at: Time.current + index)
    end

    get mission_path(error_correction), params: { input: "plus", error_qubit: "2", seed: 42 }

    assert_response :success
    assert_select "h1", "Error Correction"
    assert_select "turbo-frame#error-correction-experiment"
    assert_select "[aria-label='Error correction simulator']"
    assert_select "a[data-turbo-frame='error-correction-experiment']", 8
    assert_select "[data-stage='extract_syndrome']", /Measured syndrome: 01/
    assert_select "[aria-label='Error correction result']", /Fidelity with the original logical input/
    assert_select "[data-clue-key='2'] h3", "This code has a clear limit"
    assert_select "[data-controller=qbit-chat]"
  end

  def create_playable_mission(number, slug, prerequisite_number)
    Mission.create!(number: number, slug: slug, title: slug.humanize, summary: slug,
                    xp_reward: 100, badge_name: slug.humanize, prerequisite_number: prerequisite_number,
                    status: "playable")
  end
end
