class MissionsController < ApplicationController
  before_action :set_mission, except: :index
  before_action :require_available_mission, except: :index

  def index
    @missions = Mission.roadmap
  end

  def show
    @unlocked_mission_clues = mission_clues_for(@mission.slug)

    case @mission.slug
    when "qubit-basics"
      @lesson = QubitBasicsLesson.run(preset: params.fetch(:preset, "zero"))
      unlock_mission_clue(params[:preset]) if params[:preset].present?
      render :qubit_basics
    when "superposition"
      @lesson = SuperpositionLesson.run(preset: params.fetch(:preset, "plus"))
      unlock_mission_clue(params[:preset]) if params[:preset].present?
      render :superposition
    when "entanglement"
      @lesson = EntanglementLesson.run(shots: mission_shots, seed: mission_seed)
      unlock_mission_clue(params[:focus]) if params[:focus].present?
      render :entanglement
    when "bell-test"
      @lesson = BellTestLesson.run(shots: mission_shots, seed: mission_seed)
      unlock_mission_clue(params[:focus]) if params[:focus].present?
      render :bell_test
    when "teleportation"
      @lesson = TeleportationLesson.run(input: params.fetch(:input, "plus"), seed: mission_seed,
                                        stage: params.fetch(:stage, "prepare_input"))
      unlock_teleportation_clue if params[:stage].present?
      render :teleportation
    when "interference"
      @lesson = InterferenceLesson.run(preset: params.fetch(:preset, "reinforce_zero"))
      unlock_mission_clue(params[:preset]) if params[:preset].present?
      render :interference
    when "grovers-search"
      @lesson = GroversSearchLesson.run(marked_state: params.fetch(:marked_state, "00"), seed: mission_seed)
      unlock_mission_clue(params[:marked_state]) if params[:marked_state].present?
      render :grovers_search
    when "noise-hardware"
      @lesson = NoiseHardwareLesson.run(preset: params.fetch(:preset, "phase_flip"),
                                        shots: mission_shots, seed: mission_seed)
      unlock_mission_clue(params[:preset]) if params[:preset].present?
      render :noise_hardware
    when "error-correction"
      @lesson = ErrorCorrectionLesson.run(input: params.fetch(:input, "plus"),
                                          error_qubit: params.fetch(:error_qubit, "1"),
                                          seed: mission_seed)
      unlock_mission_clue(params[:error_qubit]) if params[:error_qubit].present?
      render :error_correction
    when "shors-factoring"
      @lesson = ShorsFactoringLesson.run(seed: params.fetch(:seed, 42))
      unlock_mission_clue(params[:seed]) if params[:seed].present?
      render :shors_factoring
    else
      redirect_to missions_path, alert: "This mission is preparing for launch."
    end
  rescue ArgumentError => error
    redirect_to mission_path(@mission), alert: error.message
  end

  def quiz
    @questions = @mission.quiz_questions.order(:id)
    @submitted_answers = {}
  end

  def submit_quiz
    result = MissionQuizGrader.call(user: Current.user, mission: @mission, answers: quiz_answers)
    @questions = @mission.quiz_questions.order(:id)
    @attempt = result.attempt
    @submitted_answers = @attempt.answers

    render :quiz, status: result.passed? ? :ok : :unprocessable_content
  end

  def qbit_chat
    reply = QbitTutor.reply(mission: @mission, question: params[:message], history: qbit_history)
    render json: { reply: reply, model: QbitTutor::MODEL }
  rescue ArgumentError => error
    render json: { error: error.message }, status: :unprocessable_content
  rescue QbitTutor::UnavailableError => error
    render json: { error: error.message }, status: :service_unavailable
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
    return Integer(params[:seed]) if params[:seed].present?

    Random.new_seed
  end

  def mission_clues_for(slug)
    session.fetch(:mission_discovery_clues_v2, {}).fetch(slug, [])
  end

  def unlock_mission_clue(key)
    key = key.to_s
    return unless MissionLearningContent.clues_for(@mission.slug).key?(key)

    all_clues = session.fetch(:mission_discovery_clues_v2, {}).deep_dup
    all_clues[@mission.slug] = Array(all_clues[@mission.slug]) | [ key ]
    session[:mission_discovery_clues_v2] = all_clues
    @unlocked_mission_clues = all_clues.fetch(@mission.slug)
  end

  def unlock_teleportation_clue
    clue_key = {
      "create_bell_pair" => "bell_pair",
      "alice_measures" => "measurements",
      "bob_corrects" => "corrections"
    }.fetch(params[:stage].to_s, nil)
    unlock_mission_clue(clue_key) if clue_key
  end

  def qbit_history
    Array(params[:history]).filter_map do |entry|
      next unless entry.respond_to?(:permit)

      entry.permit(:role, :content).to_h
    end
  end
end
