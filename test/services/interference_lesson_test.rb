# frozen_string_literal: true

require "test_helper"

class InterferenceLessonTest < ActiveSupport::TestCase
  test "H followed by H reconstructs zero through constructive interference" do
    lesson = InterferenceLesson.run(preset: "reinforce_zero")

    assert_equal 3, lesson.steps.length
    assert_in_delta 1.0, lesson.steps.last.probabilities.fetch("0"), 1e-10
    assert_in_delta 0.0, lesson.steps.last.probabilities.fetch("1"), 1e-10
    assert_equal :h, lesson.steps.last.snapshot.instruction.name
  end

  test "H then Z then H makes phase measurable as one" do
    lesson = InterferenceLesson.run(preset: "cancel_zero")

    assert_equal 4, lesson.steps.length
    assert_in_delta 0.0, lesson.steps.last.probabilities.fetch("0"), 1e-10
    assert_in_delta 1.0, lesson.steps.last.probabilities.fetch("1"), 1e-10
    assert_match(/cancel at \|0⟩/, lesson.conclusion)
  end

  test "a Z phase changes amplitudes while preserving immediate Z probabilities" do
    lesson = InterferenceLesson.run(preset: "hidden_phase")
    after_h, after_z = lesson.steps.values_at(1, 2)

    assert_equal after_h.probabilities, after_z.probabilities
    refute_equal after_h.statevector.amplitudes, after_z.statevector.amplitudes
    assert_in_delta 0.5, after_z.probabilities.fetch("0"), 1e-10
    assert_in_delta 0.5, after_z.probabilities.fetch("1"), 1e-10
  end

  test "rejects an unknown demonstration" do
    assert_raises(ArgumentError) { InterferenceLesson.run(preset: "invisible-wave") }
  end
end
