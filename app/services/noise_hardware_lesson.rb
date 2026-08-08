# frozen_string_literal: true

# Presents a small, explicit local noise model alongside an ideal QuantumRB
# circuit. It does not claim to reproduce a particular quantum device.
class NoiseHardwareLesson
  DEFAULT_SHOTS = 200

  PRESETS = {
    "clean" => {
      title: "Ideal interference check",
      gates: %i[h h],
      bit_flip_probability: 0.0,
      phase_flip_probability: 0.0,
      noise_after_instruction: 1,
      channel_label: "No errors are sampled",
      briefing: "Two H gates recombine the ideal amplitude paths, returning |0⟩ with certainty.",
      insight: "An ideal statevector simulator keeps phase perfectly. This clean result is a reference, not a promise about a physical device."
    },
    "bit_flip" => {
      title: "Sampled bit flips in a quantum channel",
      gates: [ :i ],
      bit_flip_probability: 0.25,
      phase_flip_probability: 0.0,
      noise_after_instruction: 1,
      channel_label: "25% chance of an X (bit-flip) error per run",
      briefing: "The ideal circuit keeps |0⟩. The local channel independently samples whether an X error flips that stored state before measurement.",
      insight: "A bit flip changes a Z-basis value directly: some noisy runs return 1 even though every ideal run returns 0."
    },
    "phase_flip" => {
      title: "Sampled phase flips disrupt interference",
      gates: %i[h h],
      bit_flip_probability: 0.0,
      phase_flip_probability: 0.25,
      noise_after_instruction: 1,
      channel_label: "25% chance of a Z (phase-flip) error between the H gates",
      briefing: "The first H creates two amplitude paths. A sampled Z error changes their relative phase before the second H recombines them.",
      insight: "Phase errors can be hidden before recombination, yet the final H converts them into changed Z-basis outcomes. That loss of phase control is one practical challenge for quantum hardware."
    }
  }.freeze

  Step = Struct.new(:number, :label, :statevector, keyword_init: true) do
    def probabilities = statevector.probabilities
  end

  Result = Struct.new(:preset, :title, :briefing, :insight, :channel_label, :circuit,
                      :steps, :comparison, keyword_init: true) do
    def error_rate = comparison.disturbed_shots.fdiv(comparison.noisy_result.shots)
  end

  def self.run(preset: "phase_flip", shots: DEFAULT_SHOTS, seed: 42)
    preset = preset.to_s
    configuration = PRESETS.fetch(preset) do
      raise ArgumentError, "choose a noise demonstration: #{PRESETS.keys.join(', ')}"
    end
    circuit = build_circuit(configuration.fetch(:gates))
    comparison = QuantumRB::Protocols::NoisyCircuit.run(
      circuit: circuit,
      shots: validate_shots(shots),
      bit_flip_probability: configuration.fetch(:bit_flip_probability),
      phase_flip_probability: configuration.fetch(:phase_flip_probability),
      noise_after_instruction: configuration.fetch(:noise_after_instruction),
      seed: validate_seed(seed)
    )

    Result.new(
      preset: preset,
      title: configuration.fetch(:title),
      briefing: configuration.fetch(:briefing),
      insight: configuration.fetch(:insight),
      channel_label: configuration.fetch(:channel_label),
      circuit: circuit,
      steps: describe(circuit.statevector_steps),
      comparison: comparison
    ).freeze
  end

  def self.build_circuit(gates)
    gates.reduce(QuantumRB::Circuit.new(qubits: 1)) do |circuit, gate|
      circuit.public_send(gate, 0)
    end
  end
  private_class_method :build_circuit

  def self.describe(snapshots)
    snapshots.map do |snapshot|
      Step.new(number: snapshot.index, label: label_for(snapshot), statevector: snapshot.statevector).freeze
    end.freeze
  end
  private_class_method :describe

  def self.label_for(snapshot)
    return "Start in |0⟩" unless snapshot.instruction

    { h: "Apply H", i: "Hold the ideal |0⟩ state" }.fetch(snapshot.instruction.name)
  end
  private_class_method :label_for

  def self.validate_shots(value)
    return value if value.is_a?(Integer) && value.between?(20, 2_000)

    raise ArgumentError, "shots must be an integer between 20 and 2000"
  end
  private_class_method :validate_shots

  def self.validate_seed(value)
    return value if value.is_a?(Integer)

    raise ArgumentError, "seed must be an integer"
  end
  private_class_method :validate_seed
end
