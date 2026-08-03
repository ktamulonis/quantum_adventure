class EntanglementLesson
  Result = Struct.new(:circuit, :statevector, :measurement, keyword_init: true)

  def self.run(shots: 500, seed: 42)
    circuit = QuantumRB::Experiments::BellState.build(:phi_plus)
    measurement = circuit.copy.measure_all.run(shots: shots, seed: seed)
    Result.new(circuit: circuit, statevector: circuit.statevector, measurement: measurement)
  end
end
