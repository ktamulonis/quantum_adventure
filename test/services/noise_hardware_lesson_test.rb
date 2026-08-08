# frozen_string_literal: true

require "test_helper"

class NoiseHardwareLessonTest < ActiveSupport::TestCase
  test "the ideal reference preserves the interference result" do
    lesson = NoiseHardwareLesson.run(preset: "clean", shots: 100, seed: 42)

    assert_equal({ "0" => 100 }, lesson.comparison.ideal_result.counts)
    assert_equal({ "0" => 100 }, lesson.comparison.noisy_result.counts)
    assert_equal 0, lesson.comparison.disturbed_shots
  end

  test "sampled bit flips change some deterministic zero outcomes" do
    lesson = NoiseHardwareLesson.run(preset: "bit_flip", shots: 200, seed: 42)

    assert_equal({ "0" => 200 }, lesson.comparison.ideal_result.counts)
    assert_operator lesson.comparison.noisy_result.count("1"), :>, 0
    assert_equal 200, lesson.comparison.noisy_result.counts.values.sum
    assert_operator lesson.comparison.disturbed_shots, :>, 0
  end

  test "sampled phase flips change the final interference readout" do
    lesson = NoiseHardwareLesson.run(preset: "phase_flip", shots: 200, seed: 42)

    assert_equal({ "0" => 200 }, lesson.comparison.ideal_result.counts)
    assert_operator lesson.comparison.noisy_result.count("1"), :>, 0
    assert_equal "25% chance of a Z (phase-flip) error between the H gates", lesson.channel_label
  end

  test "rejects invalid controls" do
    assert_raises(ArgumentError) { NoiseHardwareLesson.run(preset: "depolarizing") }
    assert_raises(ArgumentError) { NoiseHardwareLesson.run(shots: 1) }
    assert_raises(ArgumentError) { NoiseHardwareLesson.run(seed: "42") }
  end
end
