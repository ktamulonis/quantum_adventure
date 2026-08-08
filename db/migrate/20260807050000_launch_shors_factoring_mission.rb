# frozen_string_literal: true

class LaunchShorsFactoringMission < ActiveRecord::Migration[8.1]
  QUESTIONS = [
    [
      'What does the quantum part of this small Shor lesson reveal?',
      [ 'A period in a modular arithmetic pattern', 'The factors directly', 'Every possible divisor at once' ],
      0,
      'The quantum period-finding routine produces information about a repeating modular pattern. Classical arithmetic uses that period to find factors.'
    ],
    [
      'What period does 2^x mod 15 have in this lesson?',
      [ '2', '4', '15' ],
      1,
      'The sequence 1, 2, 4, 8 returns to 1 after four steps, so the period is 4.'
    ],
    [
      'Why does this demonstration not factor useful real-world cryptographic keys?',
      [ 'It only uses a tiny educational example and ideal simulator', 'Quantum algorithms cannot use interference', 'Factors are never related to periods' ],
      0,
      'Factoring 15 is a teaching case. Useful factoring would require much larger fault-tolerant quantum hardware and modular arithmetic circuits.'
    ]
  ].freeze

  def up
    mission = Mission.find_by!(slug: 'shors-factoring')
    mission.update!(status: 'playable', summary: 'Use quantum period finding to factor the tiny example 15 = 3 × 5.')

    QUESTIONS.each do |prompt, options, correct_option, explanation|
      QuizQuestion.find_or_initialize_by(mission: mission, prompt: prompt).update!(
        options: options,
        correct_option: correct_option,
        explanation: explanation
      )
    end
  end

  def down
    mission = Mission.find_by(slug: 'shors-factoring')
    return unless mission

    QuizQuestion.where(mission: mission, prompt: QUESTIONS.map(&:first)).delete_all
    mission.update!(status: 'coming_soon')
  end
end
