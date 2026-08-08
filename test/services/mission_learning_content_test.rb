# frozen_string_literal: true

require "test_helper"

class MissionLearningContentTest < ActiveSupport::TestCase
  test "provides a concise history story for every roadmap mission" do
    %w[
      qubit-basics superposition entanglement bell-test teleportation interference grovers-search
      noise-hardware error-correction shors-factoring
    ].each do |slug|
      story = MissionLearningContent.story_for(slug)

      assert_predicate story.fetch(:heading), :present?
      assert_predicate story.fetch(:body), :present?
      assert_predicate story.fetch(:named_for), :present?
      assert_predicate story.fetch(:resources), :present?

      story.fetch(:resources).each do |resource|
        assert_predicate resource.fetch(:label), :present?
        assert_match(%r{\Ahttps://}, resource.fetch(:url))
      end
    end
  end

  test "provides progressive simulator clues for the launched missions" do
    %w[qubit-basics superposition entanglement bell-test teleportation interference grovers-search].each do |slug|
      assert_operator MissionLearningContent.clues_for(slug).length, :>=, 3
    end
  end

  test "provides optional further-reading resources for relevant clues" do
    clue = MissionLearningContent.clues_for("shors-factoring").fetch("99")

    assert_equal "Quantum Fourier transform on Wikipedia", clue.fetch(:resources).first.fetch(:label)
  end
end
