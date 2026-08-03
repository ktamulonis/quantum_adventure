class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy
  has_many :mission_completions, dependent: :destroy
  has_many :user_badges, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :display_name, presence: true, length: { maximum: 40 }

  def total_xp = mission_completions.sum(:xp_awarded)
  def level = Progression.level_for(total_xp)
  def completed?(mission) = mission_completions.exists?(mission: mission)
end
