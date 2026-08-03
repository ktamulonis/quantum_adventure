class QubitBasicsLesson
  PRESETS = {
    "zero" => [ "|0⟩", [] ],
    "one" => [ "|1⟩", [ :x ] ],
    "plus" => [ "|+⟩", [ :h ] ]
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
end
