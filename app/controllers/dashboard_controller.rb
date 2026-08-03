class DashboardController < ApplicationController
  def show
    @missions = Mission.roadmap
    @xp = Current.user.total_xp
    @next_threshold = Progression.next_threshold_for(@xp)
  end
end
