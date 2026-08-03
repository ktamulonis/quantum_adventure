class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :mission

  validates :name, presence: true
  validates :mission_id, uniqueness: { scope: :user_id }
end
