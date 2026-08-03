class BellTestLesson
  def self.run(shots: 2_000, seed: 42)
    QuantumRB::Experiments::CHSH.new(shots: shots, seed: seed).run
  end
end
