# frozen_string_literal: true

require "test_helper"

class GroversSearchLessonTest < ActiveSupport::TestCase
  test "amplifies each marked item to certainty after one ideal iteration" do
    GroversSearchLesson::MARKED_STATES.each do |marked_state|
      lesson = GroversSearchLesson.run(marked_state: marked_state, seed: 42)

      assert_equal marked_state, lesson.marked_state
      assert_in_delta 0.25, lesson.stages[1].probabilities.fetch(marked_state), 1e-10
      assert_operator lesson.stages[2].statevector.amplitude_of(marked_state).real, :<, 0
      assert_in_delta 1.0, lesson.final_stage.probabilities.fetch(marked_state), 1e-10
      assert_equal({ marked_state => GroversSearchLesson::MEASUREMENT_SHOTS }, lesson.measurement.counts)
    end
  end

  test "keeps oracle probabilities equal while changing only the marked phase" do
    lesson = GroversSearchLesson.run(marked_state: "10", seed: 7)

    assert_equal({ "00" => 0.25, "01" => 0.25, "10" => 0.25, "11" => 0.25 }, rounded(lesson.stages[1].probabilities))
    assert_equal({ "00" => 0.25, "01" => 0.25, "10" => 0.25, "11" => 0.25 }, rounded(lesson.stages[2].probabilities))
    assert_operator lesson.stages[2].statevector.amplitude_of("10").real, :<, 0
    assert_operator lesson.stages[2].statevector.amplitude_of("00").real, :>, 0
  end

  test "rejects unknown marked states" do
    assert_raises(ArgumentError) { GroversSearchLesson.run(marked_state: "12") }
  end

  private

  def rounded(probabilities)
    probabilities.transform_values { |probability| probability.round(10) }
  end
end
