require "test_helper"

class ProgressionTest < ActiveSupport::TestCase
  test "derives levels from earned XP" do
    assert_equal 1, Progression.level_for(0)
    assert_equal 2, Progression.level_for(250)
    assert_equal 3, Progression.level_for(750)
    assert_equal 4, Progression.level_for(1_500)
  end

  test "unlocks a mission when its prerequisite is completed" do
    user = User.create!(display_name: "Ada", email_address: "ada@example.test", password: "password123")
    first = Mission.create!(number: 1, slug: "first", title: "First", summary: "First mission", xp_reward: 100,
                            badge_name: "First badge", status: "playable")
    second = Mission.create!(number: 2, slug: "second", title: "Second", summary: "Second mission", xp_reward: 100,
                             badge_name: "Second badge", prerequisite_number: 1, status: "playable")

    refute second.unlocked_for?(user)
    MissionCompletion.create!(user: user, mission: first, xp_awarded: 100, completed_at: Time.current)
    assert second.unlocked_for?(user)
    assert_equal 100, user.total_xp
  end
end
