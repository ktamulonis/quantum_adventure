# frozen_string_literal: true

class LaunchNoiseHardwareMission < ActiveRecord::Migration[8.1]
  QUESTIONS = [
    [
      'What does the ideal statevector result represent?',
      [ 'A guarantee for every physical quantum device', 'The clean mathematical reference', 'A live hardware calibration' ],
      1,
      'The ideal simulator is the clean mathematical reference used for comparison.'
    ],
    [
      'What can a sampled X error do to a stored |0⟩?',
      [ 'Turn it into |1⟩', 'Reveal a hidden answer', 'Create entanglement by itself' ],
      0,
      'X is a bit flip, so it can change a Z-basis 0 into 1.'
    ],
    [
      'Why can a phase-flip error matter even when it is not immediately visible?',
      [ 'A later interference gate can convert phase into changed probabilities', 'Phase is a classical message', 'It makes hardware perfectly reliable' ],
      0,
      'A later gate can recombine amplitude paths and make a relative phase difference measurable.'
    ]
  ].freeze

  def up
    mission = Mission.find_by!(slug: 'noise-hardware')
    mission.update!(status: 'playable', summary: 'Compare ideal simulation with a local sampled error model.')

    QUESTIONS.each do |prompt, options, correct_option, explanation|
      QuizQuestion.find_or_initialize_by(mission: mission, prompt: prompt).update!(
        options: options,
        correct_option: correct_option,
        explanation: explanation
      )
    end
  end

  def down
    mission = Mission.find_by(slug: 'noise-hardware')
    return unless mission

    QuizQuestion.where(mission: mission, prompt: QUESTIONS.map(&:first)).delete_all
    mission.update!(status: 'coming_soon')
  end
end
