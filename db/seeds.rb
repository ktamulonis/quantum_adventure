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
  [1, "qubit-basics", "Qubit Basics", "Explore one-qubit states and measurement bases.", 100, "Qubit Explorer", nil, "playable"],
  [2, "superposition", "Superposition", "Create and inspect states such as |+⟩.", 150, "Superposition Master", 1, "playable"],
  [3, "entanglement", "Entanglement", "Build Bell pairs and inspect their correlations.", 200, "Entangler", 2, "coming_soon"],
  [4, "bell-test", "Bell Test", "Run a CHSH Bell-inequality experiment.", 200, "Bell Winner", 3, "coming_soon"],
  [5, "teleportation", "Quantum Teleportation", "Teleport an unknown qubit state.", 250, "Teleporter", 4, "coming_soon"],
  [6, "interference", "Interference", "See how amplitudes add and cancel.", 150, "Interference Insider", 5, "coming_soon"],
  [7, "grovers-search", "Grover’s Search", "Find a marked item with amplitude amplification.", 300, "Grover Guide", 6, "coming_soon"],
  [8, "noise-hardware", "Noise & Real Hardware", "Compare ideal simulation with practical limitations.", 250, "Hardware Pioneer", 7, "coming_soon"],
  [9, "error-correction", "Error Correction", "Learn the intuition behind protecting quantum information.", 250, "Error Corrector", 8, "coming_soon"],
  [10, "shors-factoring", "Shor’s Factoring", "Understand period finding and factoring intuition.", 500, "Quantum Master", 9, "coming_soon"]
]

missions.each do |number, slug, title, summary, xp_reward, badge_name, prerequisite_number, status|
  Mission.find_or_initialize_by(number: number).update!(slug: slug, title: title, summary: summary,
                                                         xp_reward: xp_reward, badge_name: badge_name,
                                                         prerequisite_number: prerequisite_number, status: status)
end

quizzes = {
  "qubit-basics" => [
    ["Which value describes the chance of a measurement outcome?", ["Amplitude", "Probability", "Phase"], 1, "Probabilities give outcome chances."],
    ["Which gate flips |0⟩ to |1⟩?", ["H", "Z", "X"], 2, "The X gate is the quantum bit flip."],
    ["What does a Z-basis measurement of |0⟩ return?", ["0 with certainty", "1 with certainty", "An equal mix"], 0, "|0⟩ is the positive Z state."]
  ],
  "superposition" => [
    ["Which gate prepares |+⟩ from |0⟩?", ["X", "H", "Z"], 1, "Hadamard creates |+⟩ from |0⟩."],
    ["How does |+⟩ appear in the Z basis?", ["Always 0", "Always 1", "50/50"], 2, "|+⟩ has equal Z-basis probabilities."],
    ["How does |+⟩ appear in the X basis?", ["+ with certainty", "- with certainty", "50/50"], 0, "|+⟩ is aligned with positive X."]
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
