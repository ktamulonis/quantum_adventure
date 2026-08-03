require "test_helper"

class QuantumMissionLessonsTest < ActiveSupport::TestCase
  test "entanglement lesson creates a Bell pair with correlated measurements" do
    result = EntanglementLesson.run(shots: 100, seed: 42)

    assert_in_delta 1.0, result.statevector.concurrence
    assert_empty result.measurement.counts.keys - %w[00 11]
  end

  test "Bell test lesson violates the classical limit" do
    report = BellTestLesson.run(shots: 2_000, seed: 42)

    assert_operator report.s_value.abs, :>, 2
  end
end
