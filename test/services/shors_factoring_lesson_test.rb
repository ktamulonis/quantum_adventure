# frozen_string_literal: true

require "test_helper"

class ShorsFactoringLessonTest < ActiveSupport::TestCase
  test "delegates the period-finding example to QuantumRB" do
    lesson = ShorsFactoringLesson.run(seed: 42)

    assert lesson.protocol.successful?
    assert_equal [ 3, 5 ], lesson.protocol.factors
    assert_equal 4, lesson.protocol.period
    assert_equal "0100", lesson.protocol.measurement_outcome
    assert_equal "4/16", lesson.measurement_fraction
  end

  test "shows actual interference peaks after inverse qft" do
    lesson = ShorsFactoringLesson.run(seed: 42)
    probabilities = lesson.protocol.stages.find { |stage| stage.key == :inverse_qft }.counting_probabilities

    %w[0000 0100 1000 1100].each do |basis|
      assert_in_delta 0.25, probabilities.fetch(basis), 1e-10
    end
  end

  test "accepts only the lesson's seeded sample controls" do
    assert_raises(ArgumentError) { ShorsFactoringLesson.run(seed: 7) }
    assert_raises(ArgumentError) { ShorsFactoringLesson.run(seed: "oops") }
  end
end
