# frozen_string_literal: true

require "test_helper"

class ErrorCorrectionLessonTest < ActiveSupport::TestCase
  test "corrects one selected bit flip for each supported input state" do
    ErrorCorrectionLesson::INPUTS.each_key do |input|
      lesson = ErrorCorrectionLesson.run(input: input, error_qubit: "1", seed: 42)

      assert lesson.protocol.successful?, "#{input} should be recovered"
      assert_equal [ 1, 0 ], lesson.protocol.syndrome
      assert_equal 1, lesson.protocol.correction_qubit
      assert_in_delta 1.0, lesson.protocol.fidelity, 1e-10
    end
  end

  test "reports the matching syndrome for every selected error location" do
    expected_syndromes = {
      "none" => [ 0, 0 ],
      "0" => [ 1, 1 ],
      "1" => [ 1, 0 ],
      "2" => [ 0, 1 ]
    }

    expected_syndromes.each do |error_key, syndrome|
      lesson = ErrorCorrectionLesson.run(error_qubit: error_key, seed: 42)

      assert_equal syndrome, lesson.protocol.syndrome
      if error_key == "none"
        assert_nil lesson.protocol.correction_qubit
      else
        assert_equal error_key.to_i, lesson.protocol.correction_qubit
      end
    end
  end

  test "uses the QuantumRB trace rather than recreating state calculations" do
    lesson = ErrorCorrectionLesson.run(input: "plus", error_qubit: "2", seed: 42)

    assert_equal %i[prepare_input encode introduce_error extract_syndrome correct complete],
                 lesson.protocol.stages.map(&:key)
    assert_in_delta Math.sqrt(0.5), lesson.protocol.stages.last.data_amplitudes.fetch("000").abs, 1e-10
    assert_in_delta Math.sqrt(0.5), lesson.protocol.stages.last.data_amplitudes.fetch("111").abs, 1e-10
  end

  test "rejects invalid lesson controls" do
    assert_raises(ArgumentError) { ErrorCorrectionLesson.run(input: "plus_i") }
    assert_raises(ArgumentError) { ErrorCorrectionLesson.run(error_qubit: "3") }
    assert_raises(ArgumentError) { ErrorCorrectionLesson.run(seed: "42") }
  end
end
