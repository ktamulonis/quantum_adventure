require "test_helper"

class MissionQuizGraderTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(display_name: "Ada", email_address: "ada@example.test", password: "password123")
    @mission = Mission.create!(number: 1, slug: "qubit", title: "Qubit", summary: "Learn", xp_reward: 100,
                               badge_name: "Qubit Explorer", status: "playable")
    @questions = 3.times.map do |index|
      QuizQuestion.create!(mission: @mission, prompt: "Question #{index}", options: ["A", "B"], correct_option: 0,
                           explanation: "Because")
    end
  end

  test "awards XP and one badge on a passing first attempt" do
    answers = @questions.to_h { |question| [question.id.to_s, "0"] }

    result = MissionQuizGrader.call(user: @user, mission: @mission, answers: answers)

    assert result.passed?
    assert_equal 100, @user.total_xp
    assert_equal ["Qubit Explorer"], @user.user_badges.pluck(:name)
  end

  test "records a failed attempt without granting completion" do
    answers = @questions.to_h { |question| [question.id.to_s, "1"] }

    result = MissionQuizGrader.call(user: @user, mission: @mission, answers: answers)

    refute result.passed?
    assert_equal 0, @user.total_xp
    assert_empty @user.user_badges
  end
end
