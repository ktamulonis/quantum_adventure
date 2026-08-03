class QubitBasicsLesson
  PRESETS = {
    "zero" => [ "|0⟩", [] ],
    "one" => [ "|1⟩", [ :x ] ],
    "plus" => [ "|+⟩", [ :h ] ]
  }.freeze

  CLUES = {
    "zero" => {
      title: "A measurement has probabilities, not hidden answers",
      body: "The Z card shows 0 at 100% for |0⟩. Those percentages are probabilities: they tell you the chance of each possible measurement outcome."
    },
    "one" => {
      title: "The X gate is the quantum bit flip",
      body: "This preparation starts at |0⟩ and applies X. The state becomes |1⟩, so a Z measurement returns 1 with certainty."
    },
    "plus" => {
      title: "A qubit can be predictable in one basis and random in another",
      body: "H prepares |+⟩. It looks 50/50 in the Z basis, but the X card shows + at 100%. The state is not a classical coin flip."
    }
  }.freeze

  Result = Struct.new(:preset, :state_name, :circuit, :statevector, keyword_init: true)

  def self.run(preset: "zero")
    state_name, gates = PRESETS.fetch(preset)
    circuit = QuantumRB::Circuit.new(qubits: 1)
    gates.each { |gate| circuit.public_send(gate, 0) }
    Result.new(preset: preset, state_name: state_name, circuit: circuit, statevector: circuit.statevector)
  rescue KeyError
    raise ArgumentError, "unknown qubit preset"
  end

  def self.clue_for(preset)
    CLUES.fetch(preset)
  end
end
