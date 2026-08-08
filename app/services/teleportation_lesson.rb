class TeleportationLesson
  INPUTS = {
    "zero" => "|0⟩",
    "one" => "|1⟩",
    "plus" => "|+⟩",
    "minus" => "|−⟩",
    "plus_i" => "|+i⟩",
    "minus_i" => "|−i⟩"
  }.freeze

  Result = Struct.new(:protocol, :stage, :stage_number, :input_name, keyword_init: true)

  def self.run(input: "plus", seed: 42, stage: "prepare_input")
    input = input.to_s
    raise ArgumentError, "unknown teleportation input" unless INPUTS.key?(input)

    protocol = QuantumRB::Protocols::Teleportation.run(input: input.to_sym, seed: seed)
    stage_number = protocol.stages.index { |entry| entry.key == stage.to_sym }
    raise ArgumentError, "unknown teleportation stage" unless stage_number

    Result.new(protocol: protocol, stage: protocol.stages.fetch(stage_number), stage_number: stage_number,
               input_name: INPUTS.fetch(input))
  end
end
