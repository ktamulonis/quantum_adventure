# frozen_string_literal: true

# Presents QuantumRB's deliberately small Shor period-finding trace without
# recreating any quantum mathematics in Rails. The lesson factors 15 with base
# 2 so every step can remain visible and understandable.
class ShorsFactoringLesson
  SEEDS = {
    "42" => "Run a period sample (seed 42)",
    "17" => "Try another period sample (seed 17)",
    "99" => "Try a third sample (seed 99)"
  }.freeze

  Result = Struct.new(:seed, :protocol, keyword_init: true) do
    def measurement_fraction
      "#{protocol.measurement_outcome.to_i(2)}/16"
    end

    def attempts_label
      protocol.measurement_attempts.join(" → ")
    end
  end

  def self.run(seed: 42)
    seed = Integer(seed)
    raise ArgumentError, "choose one of the lesson samples" unless SEEDS.key?(seed.to_s)

    Result.new(seed: seed, protocol: QuantumRB::Protocols::ShorFactoring.run(seed: seed)).freeze
  rescue ArgumentError, TypeError
    raise ArgumentError, "choose one of the lesson samples"
  end
end
