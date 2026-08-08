class DashboardController < ApplicationController
  def show
    @missions = Mission.roadmap
    @xp = Current.user.total_xp
    @next_threshold = Progression.next_threshold_for(@xp)
    @latest_quiz_attempts = Current.user.quiz_attempts.order(created_at: :desc, id: :desc).each_with_object({}) do |attempt, latest|
      latest[attempt.mission_id] ||= attempt
    end
  end
end
