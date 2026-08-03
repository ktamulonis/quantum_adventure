class MissionsController < ApplicationController
  before_action :set_mission, except: :index
  before_action :require_available_mission, except: :index

  def index
    @missions = Mission.roadmap
  end

  def show
    case @mission.slug
    when "qubit-basics"
      @lesson = QubitBasicsLesson.run(preset: params.fetch(:preset, "zero"))
      render :qubit_basics
    when "superposition"
      @lesson = SuperpositionLesson.run(preset: params.fetch(:preset, "plus"))
      render :superposition
    when "entanglement"
      @lesson = EntanglementLesson.run(shots: mission_shots, seed: mission_seed)
      render :entanglement
    when "bell-test"
      @lesson = BellTestLesson.run(shots: mission_shots, seed: mission_seed)
      render :bell_test
    else
      redirect_to missions_path, alert: "This mission is preparing for launch."
    end
  rescue ArgumentError => error
    redirect_to mission_path(@mission), alert: error.message
  end

  def quiz
    @questions = @mission.quiz_questions.order(:id)
  end

  def submit_quiz
    result = MissionQuizGrader.call(user: Current.user, mission: @mission, answers: quiz_answers)
    if result.passed?
      redirect_to root_path, notice: "Mission complete! You earned #{@mission.xp_reward} XP and the #{@mission.badge_name} badge."
    else
      redirect_to quiz_mission_path(@mission), alert: "#{result.attempt.score_percent}% — review the lesson and try again."
    end
  end

  private

  def set_mission
    @mission = Mission.find_by!(slug: params[:slug])
  end

  def require_available_mission
    return if @mission.status == "playable" && @mission.unlocked_for?(Current.user)

    redirect_to missions_path, alert: "Complete the prerequisite mission to unlock this ticket."
  end

  def quiz_answers
    params.fetch(:answers, {}).permit!.to_h
  end

  def mission_shots
    value = Integer(params.fetch(:shots, 500))
    raise ArgumentError, "shots must be between 100 and 10000" unless value.between?(100, 10_000)

    value
  end

  def mission_seed
    Integer(params.fetch(:seed, 42))
  end
end
