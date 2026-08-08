# frozen_string_literal: true

class LaunchInterferenceMission < ActiveRecord::Migration[8.1]
  QUESTIONS = [
    [
      'Which gate can recombine two amplitude paths?',
      [ 'X', 'Z', 'H' ],
      2,
      'Hadamard can split and recombine amplitudes.'
    ],
    [
      'Starting from |0⟩, what does H then Z then H produce?',
      [ '|0⟩ with certainty', '|1⟩ with certainty', 'A 50/50 mixture' ],
      1,
      'Z changes a relative phase, so the final H makes the paths cancel at |0⟩ and reinforce at |1⟩.'
    ],
    [
      'Why can H then Z still look 50/50 in a Z measurement?',
      [ 'Relative phase changes later interference, not immediate Z probabilities', 'Z deletes the |1⟩ amplitude', 'The qubit becomes a classical coin' ],
      0,
      'The relative phase is not visible in an immediate Z measurement, but a later H can reveal it through interference.'
    ]
  ].freeze

  def up
    mission = Mission.find_by!(slug: 'interference')
    mission.update!(status: 'playable', summary: 'See how amplitudes add and cancel.')

    QUESTIONS.each do |prompt, options, correct_option, explanation|
      QuizQuestion.find_or_initialize_by(mission: mission, prompt: prompt).update!(options: options,
                                                                                    correct_option: correct_option,
                                                                                    explanation: explanation)
    end
  end

  def down
    mission = Mission.find_by(slug: 'interference')
    return unless mission

    QuizQuestion.where(mission: mission, prompt: QUESTIONS.map(&:first)).delete_all
    mission.update!(status: 'coming_soon')
  end
end
