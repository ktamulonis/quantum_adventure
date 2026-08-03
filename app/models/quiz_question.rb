class QuizQuestion < ApplicationRecord
  belongs_to :mission

  validates :prompt, :explanation, presence: true
  validates :correct_option, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :correct_option_is_available

  private

  def correct_option_is_available
    errors.add(:correct_option, "must identify an option") unless options.is_a?(Array) && options[correct_option]
  end
end
