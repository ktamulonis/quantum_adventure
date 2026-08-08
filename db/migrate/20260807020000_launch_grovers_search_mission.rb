# frozen_string_literal: true

class LaunchGroversSearchMission < ActiveRecord::Migration[8.1]
  QUESTIONS = [
    [
      'What does Grover’s oracle do to the marked state?',
      [ 'It reveals the answer directly', 'It flips the marked state’s phase', 'It measures every candidate' ],
      1,
      'The oracle changes phase; it does not announce the marked answer.'
    ],
    [
      'Which step converts the phase mark into a higher measurement probability?',
      [ 'Diffusion (amplitude amplification)', 'A classical message', 'Reset' ],
      0,
      'The diffusion step recombines amplitudes so the marked state reinforces.'
    ],
    [
      'How many Grover iterations are needed in this ideal four-item lesson?',
      [ 'One', 'Four', 'None' ],
      0,
      'With one marked item among four, one ideal Grover iteration amplifies the target to certainty.'
    ]
  ].freeze

  def up
    mission = Mission.find_by!(slug: 'grovers-search')
    mission.update!(status: 'playable', summary: 'Find a marked item with amplitude amplification.')

    QUESTIONS.each do |prompt, options, correct_option, explanation|
      QuizQuestion.find_or_initialize_by(mission: mission, prompt: prompt).update!(options: options,
                                                                                    correct_option: correct_option,
                                                                                    explanation: explanation)
    end
  end

  def down
    mission = Mission.find_by(slug: 'grovers-search')
    return unless mission

    QuizQuestion.where(mission: mission, prompt: QUESTIONS.map(&:first)).delete_all
    mission.update!(status: 'coming_soon')
  end
end
