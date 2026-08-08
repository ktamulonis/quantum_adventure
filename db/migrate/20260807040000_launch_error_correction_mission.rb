# frozen_string_literal: true

class LaunchErrorCorrectionMission < ActiveRecord::Migration[8.1]
  QUESTIONS = [
    [
      'What do the syndrome qubits reveal in this lesson?',
      [ 'Which physical qubit flipped', 'The unknown logical value', 'A copied version of the input' ],
      0,
      'The parity syndrome identifies the physical location of one bit flip without directly reading the logical state.'
    ],
    [
      'Why does the three-qubit code use redundancy instead of making a simple copy?',
      [ 'Unknown quantum states cannot be cloned independently', 'Copies would use too few qubits', 'It is only a visual preference' ],
      0,
      'Quantum encoding creates a joint codeword; it does not make independent copies of an unknown state.'
    ],
    [
      'Which error does this repetition-code lesson correct?',
      [ 'One bit flip (X error)', 'Every phase error', 'Any number of errors' ],
      0,
      'This small code corrects one X error. More complete codes are needed for phase errors and multiple errors.'
    ]
  ].freeze

  def up
    mission = Mission.find_by!(slug: 'error-correction')
    mission.update!(status: 'playable', summary: 'Use redundancy and a syndrome to correct one bit flip.')

    QUESTIONS.each do |prompt, options, correct_option, explanation|
      QuizQuestion.find_or_initialize_by(mission: mission, prompt: prompt).update!(
        options: options,
        correct_option: correct_option,
        explanation: explanation
      )
    end
  end

  def down
    mission = Mission.find_by(slug: 'error-correction')
    return unless mission

    QuizQuestion.where(mission: mission, prompt: QUESTIONS.map(&:first)).delete_all
    mission.update!(status: 'coming_soon')
  end
end
