class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :mission

  validates :correct_count, :question_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :passed, inclusion: { in: [ true, false ] }

  def score_percent
    return 0 if question_count.zero?

    (correct_count.fdiv(question_count) * 100).round
  end
end
