require "test_helper"

class TeleportationLessonTest < ActiveSupport::TestCase
  test "uses the QuantumRB teleportation protocol and exposes an educational stage" do
    lesson = TeleportationLesson.run(input: "plus", seed: 42, stage: "bob_corrects")

    assert_equal "|+⟩", lesson.input_name
    assert_equal :bob_corrects, lesson.stage.key
    assert lesson.stage.alice_has_measured
    assert lesson.stage.classical_bits_sent
    assert lesson.stage.bob_has_corrected
    assert lesson.protocol.successful?
    assert_in_delta 1.0, lesson.protocol.fidelity, 1e-10
  end

  test "rejects unsupported inputs and stage names" do
    assert_raises(ArgumentError) { TeleportationLesson.run(input: "diagonal") }
    assert_raises(ArgumentError) { TeleportationLesson.run(stage: "not-a-stage") }
  end
end
