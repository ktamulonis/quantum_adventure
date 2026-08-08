# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
missions = [
  [ 1, "qubit-basics", "Qubit Basics", "Explore one-qubit states and measurement bases.", 100, "Qubit Explorer", nil, "playable" ],
  [ 2, "superposition", "Superposition", "Create and inspect states such as |+⟩.", 150, "Superposition Master", 1, "playable" ],
  [ 3, "entanglement", "Entanglement", "Build Bell pairs and inspect their correlations.", 200, "Entangler", 2, "playable" ],
  [ 4, "bell-test", "Bell Test", "Run a CHSH Bell-inequality experiment.", 200, "Bell Winner", 3, "playable" ],
  [ 5, "teleportation", "Quantum Teleportation", "Transfer a qubit state using entanglement and classical bits.", 250, "Teleporter", 4, "playable" ],
  [ 6, "interference", "Interference", "See how amplitudes add and cancel.", 150, "Interference Insider", 5, "playable" ],
  [ 7, "grovers-search", "Grover’s Search", "Find a marked item with amplitude amplification.", 300, "Grover Guide", 6, "coming_soon" ],
  [ 8, "noise-hardware", "Noise & Real Hardware", "Compare ideal simulation with practical limitations.", 250, "Hardware Pioneer", 7, "coming_soon" ],
  [ 9, "error-correction", "Error Correction", "Learn the intuition behind protecting quantum information.", 250, "Error Corrector", 8, "coming_soon" ],
  [ 10, "shors-factoring", "Shor’s Factoring", "Understand period finding and factoring intuition.", 500, "Quantum Master", 9, "coming_soon" ]
]

missions.each do |number, slug, title, summary, xp_reward, badge_name, prerequisite_number, status|
  Mission.find_or_initialize_by(number: number).update!(slug: slug, title: title, summary: summary,
                                                         xp_reward: xp_reward, badge_name: badge_name,
                                                         prerequisite_number: prerequisite_number, status: status)
end

quizzes = {
  "qubit-basics" => [
    [ "Which value describes the chance of a measurement outcome?", [ "Amplitude", "Probability", "Phase" ], 1, "Probabilities give outcome chances." ],
    [ "Which gate flips |0⟩ to |1⟩?", [ "H", "Z", "X" ], 2, "The X gate is the quantum bit flip." ],
    [ "What does a Z-basis measurement of |0⟩ return?", [ "0 with certainty", "1 with certainty", "An equal mix" ], 0, "|0⟩ is the positive Z state." ]
  ],
  "superposition" => [
    [ "Which gate prepares |+⟩ from |0⟩?", [ "X", "H", "Z" ], 1, "Hadamard creates |+⟩ from |0⟩." ],
    [ "How does |+⟩ appear in the Z basis?", [ "Always 0", "Always 1", "50/50" ], 2, "|+⟩ has equal Z-basis probabilities." ],
    [ "How does |+⟩ appear in the X basis?", [ "+ with certainty", "- with certainty", "50/50" ], 0, "|+⟩ is aligned with positive X." ]
  ],
  "entanglement" => [
    [ "Which state is prepared by H on q0 followed by CX q0→q1?", [ "A Bell pair", "A classical bit", "A reset state" ], 0, "Those gates prepare phi-plus." ],
    [ "What concurrence does an ideal Bell pair have?", [ "0", "0.5", "1" ], 2, "Bell pairs are maximally entangled." ],
    [ "Which outcomes occur for phi-plus in the computational basis?", [ "00 and 11", "01 and 10", "All equally" ], 0, "The ideal phi-plus pair is correlated." ]
  ],
  "bell-test" => [
    [ "What is the CHSH classical limit?", [ "1", "2", "2√2" ], 1, "Local hidden-variable models are bounded by 2." ],
    [ "What ideal value can quantum mechanics approach?", [ "0", "2", "2√2" ], 2, "The ideal quantum maximum is 2√2." ],
    [ "Do Bell correlations allow faster-than-light messaging?", [ "Yes", "No", "Only with hardware" ], 1, "Correlations cannot transmit chosen messages instantly." ]
  ],
  "teleportation" => [
    [ "What is transferred in quantum teleportation?", [ "A physical particle", "A quantum state", "A faster-than-light message" ], 1, "Teleportation transfers quantum-state information, not matter." ],
    [ "Why must Alice send two ordinary bits to Bob?", [ "Bob needs them to choose corrections", "They create entanglement", "They copy Alice’s qubit" ], 0, "Bob uses Alice’s measurement bits to select the required X and Z corrections." ],
    [ "What happens to Alice’s original input state after her measurement?", [ "It remains as a second copy", "It is consumed by measurement", "It travels physically to Bob" ], 1, "Measurement consumes Alice’s independently available input state, so teleportation does not clone it." ]
  ],
  "interference" => [
    [ "Which gate can recombine two amplitude paths?", [ "X", "Z", "H" ], 2, "Hadamard can split and recombine amplitudes." ],
    [ "Starting from |0⟩, what does H then Z then H produce?", [ "|0⟩ with certainty", "|1⟩ with certainty", "A 50/50 mixture" ], 1, "Z changes a relative phase, so the final H makes the paths cancel at |0⟩ and reinforce at |1⟩." ],
    [ "Why can H then Z still look 50/50 in a Z measurement?", [ "Relative phase changes later interference, not immediate Z probabilities", "Z deletes the |1⟩ amplitude", "The qubit becomes a classical coin" ], 0, "The relative phase is not visible in an immediate Z measurement, but a later H can reveal it through interference." ]
  ]
}

quizzes.each do |slug, questions|
  mission = Mission.find_by!(slug: slug)
  questions.each do |prompt, options, correct_option, explanation|
    QuizQuestion.find_or_initialize_by(mission: mission, prompt: prompt).update!(options: options,
                                                                                   correct_option: correct_option,
                                                                                   explanation: explanation)
  end
end
