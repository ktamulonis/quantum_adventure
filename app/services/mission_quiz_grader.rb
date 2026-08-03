class MissionQuizGrader
  PASSING_PERCENT = 70

  Result = Struct.new(:attempt, :completion, :badge, keyword_init: true) do
    def passed? = attempt.passed?
  end

  def self.call(user:, mission:, answers:)
    questions = mission.quiz_questions.order(:id)
    correct_count = questions.count do |question|
      answers.fetch(question.id.to_s, "").to_i == question.correct_option
    end
    passed = questions.any? && correct_count.fdiv(questions.count) * 100 >= PASSING_PERCENT
    attempt = user.quiz_attempts.create!(mission: mission, answers: answers, correct_count: correct_count,
                                         question_count: questions.count, passed: passed)
    completion = badge = nil

    if passed
      completion = user.mission_completions.find_or_create_by!(mission: mission) do |record|
        record.xp_awarded = mission.xp_reward
        record.completed_at = Time.current
      end
      badge = user.user_badges.find_or_create_by!(mission: mission) { |record| record.name = mission.badge_name }
    end

    Result.new(attempt: attempt, completion: completion, badge: badge)
  end
end
