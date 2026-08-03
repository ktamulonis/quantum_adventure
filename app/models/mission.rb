class Mission < ApplicationRecord
  has_many :quiz_questions, dependent: :destroy
  has_many :mission_completions, dependent: :destroy
  has_many :user_badges, dependent: :destroy

  validates :number, :slug, :title, :summary, :badge_name, presence: true
  validates :number, :xp_reward, numericality: { only_integer: true, greater_than: 0 }
  validates :number, :slug, uniqueness: true

  scope :roadmap, -> { order(:number) }

  def to_param = slug

  def unlocked_for?(user)
    prerequisite_number.nil? || user.mission_completions.joins(:mission).exists?(missions: { number: prerequisite_number })
  end
end
