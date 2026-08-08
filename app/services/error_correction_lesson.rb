# frozen_string_literal: true

# Labels the immutable QuantumRB repetition-code trace for Mission 9. All
# encoding, syndrome measurement, correction, and fidelity calculations remain
# inside QuantumRB.
class ErrorCorrectionLesson
  INPUTS = {
    "zero" => "Protect |0⟩",
    "one" => "Protect |1⟩",
    "plus" => "Protect |+⟩",
    "minus" => "Protect |−⟩"
  }.freeze

  ERROR_OPTIONS = {
    "none" => "No injected error",
    "0" => "Flip physical qubit q0",
    "1" => "Flip physical qubit q1",
    "2" => "Flip physical qubit q2"
  }.freeze

  Result = Struct.new(:input, :error_key, :protocol, keyword_init: true) do
    def correction_message
      return "The syndrome is 00, so no correction is needed." if protocol.correction_qubit.nil?

      "Syndrome #{protocol.syndrome.join} identifies q#{protocol.correction_qubit}; apply X to that physical qubit."
    end
  end

  def self.run(input: "plus", error_qubit: "1", seed: 42)
    input = input.to_s
    error_key = error_qubit.to_s
    raise ArgumentError, "choose a protected state: #{INPUTS.keys.join(', ')}" unless INPUTS.key?(input)
    raise ArgumentError, "choose an error demonstration: #{ERROR_OPTIONS.keys.join(', ')}" unless ERROR_OPTIONS.key?(error_key)
    raise ArgumentError, "seed must be an integer" unless seed.is_a?(Integer)

    protocol_error = error_key == "none" ? :none : Integer(error_key)
    Result.new(
      input: input,
      error_key: error_key,
      protocol: QuantumRB::Protocols::BitFlipErrorCorrection.run(
        input: input.to_sym,
        error_qubit: protocol_error,
        seed: seed
      )
    ).freeze
  end
end
