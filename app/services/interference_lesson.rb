# frozen_string_literal: true

# Builds the small, real one-qubit circuits used by Mission 6. The lesson
# presents QuantumRB's immutable state snapshots; it does not reproduce any
# gate or amplitude calculations in Rails.
class InterferenceLesson
  PRESETS = {
    "reinforce_zero" => {
      title: "Constructive interference toward |0⟩",
      gates: %i[h h],
      briefing: "The first H splits amplitude into two paths. The second H recombines paths that are in phase, so they reinforce at |0⟩.",
      conclusion: "Both paths add at |0⟩ and cancel at |1⟩. The final Z-basis measurement is 0 with certainty."
    },
    "cancel_zero" => {
      title: "Destructive interference at |0⟩",
      gates: %i[h z h],
      briefing: "The first H splits amplitude. Z changes the relative phase of one path. The final H recombines those paths differently.",
      conclusion: "The changed phase makes the paths cancel at |0⟩ and reinforce at |1⟩. The final Z-basis measurement is 1 with certainty."
    },
    "hidden_phase" => {
      title: "A phase change can be hidden from an immediate measurement",
      gates: %i[h z],
      briefing: "H and then Z creates |−⟩. Its Z-basis probabilities are still 50/50, even though its |1⟩ amplitude has changed sign.",
      conclusion: "A later H would turn this otherwise hidden relative phase into a different measurable outcome. That is the interference resource quantum algorithms use."
    }
  }.freeze

  Step = Struct.new(:number, :label, :explanation, :snapshot, keyword_init: true) do
    def statevector = snapshot.statevector
    def probabilities = snapshot.probabilities
    def bloch_vector = snapshot.bloch_vector
  end

  Result = Struct.new(:preset, :title, :briefing, :conclusion, :circuit, :steps, keyword_init: true)

  def self.run(preset: "reinforce_zero")
    preset = preset.to_s
    configuration = PRESETS.fetch(preset) { raise ArgumentError, "unknown interference demonstration" }
    circuit = build_circuit(configuration.fetch(:gates))

    Result.new(preset: preset, title: configuration.fetch(:title), briefing: configuration.fetch(:briefing),
               conclusion: configuration.fetch(:conclusion), circuit: circuit,
               steps: describe(circuit.statevector_steps).freeze).freeze
  end

  def self.build_circuit(gates)
    gates.reduce(QuantumRB::Circuit.new(qubits: 1)) { |circuit, gate| circuit.public_send(gate, 0) }
  end
  private_class_method :build_circuit

  def self.describe(snapshots)
    snapshots.map do |snapshot|
      Step.new(number: snapshot.index, label: step_label(snapshot), explanation: step_explanation(snapshot),
               snapshot: snapshot).freeze
    end
  end
  private_class_method :describe

  def self.step_label(snapshot)
    return "Start in |0⟩" unless snapshot.instruction

    { h: "Apply H", z: "Apply Z" }.fetch(snapshot.instruction.name, "Apply #{snapshot.instruction.name.to_s.upcase}")
  end
  private_class_method :step_label

  def self.step_explanation(snapshot)
    return "The qubit begins in |0⟩: one certain Z-basis outcome." unless snapshot.instruction

    case snapshot.instruction.name
    when :h
      snapshot.index == 1 ? "H creates two amplitude paths with equal weight." : "H recombines the paths, making their relative phase visible as probabilities."
    when :z
      "Z changes the relative phase of the |1⟩ path without changing the immediate Z-basis probabilities."
    else
      "This gate changes the state before the next measurement."
    end
  end
  private_class_method :step_explanation
end
