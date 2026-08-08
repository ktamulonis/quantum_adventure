# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_07_040000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "mission_completions", force: :cascade do |t|
    t.datetime "completed_at", null: false
    t.datetime "created_at", null: false
    t.bigint "mission_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "xp_awarded", null: false
    t.index ["mission_id"], name: "index_mission_completions_on_mission_id"
    t.index ["user_id", "mission_id"], name: "index_mission_completions_on_user_id_and_mission_id", unique: true
    t.index ["user_id"], name: "index_mission_completions_on_user_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string "badge_name", null: false
    t.datetime "created_at", null: false
    t.integer "number", null: false
    t.integer "prerequisite_number"
    t.string "slug", null: false
    t.string "status", default: "coming_soon", null: false
    t.text "summary", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "xp_reward", null: false
    t.index ["number"], name: "index_missions_on_number", unique: true
    t.index ["slug"], name: "index_missions_on_slug", unique: true
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.jsonb "answers", default: {}, null: false
    t.integer "correct_count", null: false
    t.datetime "created_at", null: false
    t.bigint "mission_id", null: false
    t.boolean "passed", null: false
    t.integer "question_count", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["mission_id"], name: "index_quiz_attempts_on_mission_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.integer "correct_option", null: false
    t.datetime "created_at", null: false
    t.text "explanation", null: false
    t.bigint "mission_id", null: false
    t.jsonb "options", default: [], null: false
    t.text "prompt", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_quiz_questions_on_mission_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_badges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "mission_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["mission_id"], name: "index_user_badges_on_mission_id"
    t.index ["user_id", "mission_id"], name: "index_user_badges_on_user_id_and_mission_id", unique: true
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name", default: "Quantum Explorer", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "mission_completions", "missions"
  add_foreign_key "mission_completions", "users"
  add_foreign_key "quiz_attempts", "missions"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "quiz_questions", "missions"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_badges", "missions"
  add_foreign_key "user_badges", "users"
end
