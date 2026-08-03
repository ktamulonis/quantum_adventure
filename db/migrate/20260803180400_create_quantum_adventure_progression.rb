class CreateQuantumAdventureProgression < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :display_name, :string, null: false, default: "Quantum Explorer"

    create_table :missions do |t|
      t.integer :number, null: false
      t.string :slug, null: false
      t.string :title, null: false
      t.text :summary, null: false
      t.integer :xp_reward, null: false
      t.string :badge_name, null: false
      t.integer :prerequisite_number
      t.string :status, null: false, default: "coming_soon"

      t.timestamps
    end
    add_index :missions, :number, unique: true
    add_index :missions, :slug, unique: true

    create_table :quiz_questions do |t|
      t.references :mission, null: false, foreign_key: true
      t.text :prompt, null: false
      t.jsonb :options, null: false, default: []
      t.integer :correct_option, null: false
      t.text :explanation, null: false

      t.timestamps
    end

    create_table :quiz_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mission, null: false, foreign_key: true
      t.jsonb :answers, null: false, default: {}
      t.integer :correct_count, null: false
      t.integer :question_count, null: false
      t.boolean :passed, null: false

      t.timestamps
    end

    create_table :mission_completions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mission, null: false, foreign_key: true
      t.integer :xp_awarded, null: false
      t.datetime :completed_at, null: false

      t.timestamps
    end
    add_index :mission_completions, %i[user_id mission_id], unique: true

    create_table :user_badges do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mission, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
    add_index :user_badges, %i[user_id mission_id], unique: true
  end
end
