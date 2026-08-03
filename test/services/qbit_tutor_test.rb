require "test_helper"

class QbitTutorTest < ActiveSupport::TestCase
  setup do
    @mission = Mission.create!(number: 1, slug: "qubit-basics", title: "Qubit Basics", summary: "Learn qubits",
                               xp_reward: 100, badge_name: "Qubit Explorer", status: "playable")
  end

  test "builds a Q-Bit prompt with the current lesson controls" do
    prompt = QbitTutor.system_prompt_for(@mission)

    assert_includes prompt, "Prepare |0> runs no gate"
    assert_includes prompt, "Prepare |1> runs X"
    assert_includes prompt, "Prepare |+> runs H"
    assert_includes prompt, "Bloch vector"
  end

  test "rejects an empty question before contacting Ollama" do
    assert_raises(ArgumentError) { QbitTutor.reply(mission: @mission, question: "") }
  end

  test "returns only Q-Bit's final answer when Ollama includes a thinking trace" do
    reply = QbitTutor.send(:extract_reply, "internal reasoning\n</think>\nPrepare |+⟩ applies H to |0⟩.")

    assert_equal "Prepare |+⟩ applies H to |0⟩.", reply
  end
end
