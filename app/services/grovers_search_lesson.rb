# frozen_string_literal: true

# Builds the smallest honest Grover search demonstration: one marked item in a
# four-item search space. All amplitudes and measurement results come from
# QuantumRB circuits; this class only chooses and labels the teaching stages.
class GroversSearchLesson
  MARKED_STATES = %w[00 01 10 11].freeze
  MEASUREMENT_SHOTS = 20

  Stage = Struct.new(:key, :title, :explanation, :statevector, keyword_init: true) do
    def probabilities = statevector.probabilities
  end

  Result = Struct.new(:marked_state, :circuit, :stages, :measurement, keyword_init: true) do
    def final_stage = stages.last
  end

  def self.run(marked_state: "00", seed: 42)
    marked_state = marked_state.to_s
    raise ArgumentError, "choose a marked state: #{MARKED_STATES.join(', ')}" unless MARKED_STATES.include?(marked_state)

    circuit = QuantumRB::Circuit.new(qubits: 2)
    stages = [ stage(:initial, "Initial state", "The search begins at |00⟩. No answer is favored yet.", circuit) ]

    circuit.h(0).h(1)
    stages << stage(:superposition, "Equal superposition", "H on both qubits gives all four candidates equal amplitude and a 25% measurement probability.", circuit)

    apply_oracle(circuit, marked_state)
    stages << stage(:oracle, "After the phase oracle", "The oracle marks |#{marked_state}⟩ by flipping only its phase. Every candidate still has the same 25% probability, so the answer has not been revealed yet.", circuit)

    apply_diffusion(circuit)
    stages << stage(:diffusion, "After diffusion", "Diffusion recombines the amplitudes. The marked path reinforces while the other three cancel in this four-item, one-iteration example.", circuit)

    measurement = circuit.copy.measure_all.run(shots: MEASUREMENT_SHOTS, seed: seed)
    stages << stage(:measurement, "Measurement result", "Only now is the amplified state measured. The ideal simulator returns the marked item |#{marked_state}⟩ with certainty.", circuit)

    Result.new(marked_state: marked_state, circuit: circuit, stages: stages.freeze, measurement: measurement).freeze
  end

  def self.apply_oracle(circuit, marked_state)
    marked_state.chars.reverse.each_with_index do |bit, qubit|
      circuit.x(qubit) if bit == "0"
    end
    circuit.cz(0, 1)
    marked_state.chars.reverse.each_with_index do |bit, qubit|
      circuit.x(qubit) if bit == "0"
    end
  end
  private_class_method :apply_oracle

  def self.apply_diffusion(circuit)
    circuit.h(0).h(1).x(0).x(1).cz(0, 1).x(0).x(1).h(0).h(1)
  end
  private_class_method :apply_diffusion

  def self.stage(key, title, explanation, circuit)
    Stage.new(key: key, title: title, explanation: explanation, statevector: circuit.statevector).freeze
  end
  private_class_method :stage
end
