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
  [3, "entanglement", "Entanglement", "Build Bell pairs and inspect their correlations.", 200, "Entangler", 2, "playable"],
  [4, "bell-test", "Bell Test", "Run a CHSH Bell-inequality experiment.", 200, "Bell Winner", 3, "playable"],
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
