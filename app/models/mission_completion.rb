class MissionCompletion < ApplicationRecord
  belongs_to :user
  belongs_to :mission

  validates :xp_awarded, numericality: { only_integer: true, greater_than: 0 }
  validates :mission_id, uniqueness: { scope: :user_id }
end
