class LaunchQuantumTeleportationMission < ActiveRecord::Migration[8.1]
  QUESTIONS = [
    [
      'What is transferred in quantum teleportation?',
      [ 'A physical particle', 'A quantum state', 'A faster-than-light message' ],
      1,
      'Teleportation transfers quantum-state information, not matter.'
    ],
    [
      'Why must Alice send two ordinary bits to Bob?',
      [ 'Bob needs them to choose corrections', 'They create entanglement', 'They copy Alice’s qubit' ],
      0,
      'Bob uses Alice’s measurement bits to select the required X and Z corrections.'
    ],
    [
      'What happens to Alice’s original input state after her measurement?',
      [ 'It remains as a second copy', 'It is consumed by measurement', 'It travels physically to Bob' ],
      1,
      'Measurement consumes Alice’s independently available input state, so teleportation does not clone it.'
    ]
  ].freeze

  def up
    mission = Mission.find_by!(slug: 'teleportation')
    mission.update!(status: 'playable', summary: 'Transfer a qubit state using entanglement and classical bits.')

    QUESTIONS.each do |prompt, options, correct_option, explanation|
      QuizQuestion.find_or_initialize_by(mission: mission, prompt: prompt).update!(options: options,
                                                                                    correct_option: correct_option,
                                                                                    explanation: explanation)
    end
  end

  def down
    mission = Mission.find_by(slug: 'teleportation')
    return unless mission

    QuizQuestion.where(mission: mission, prompt: QUESTIONS.map(&:first)).delete_all
    mission.update!(status: 'coming_soon', summary: 'Teleport an unknown qubit state.')
  end
end
