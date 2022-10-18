# This is a version of the user track for when we
# don't have a logged in user but we still want to
# have the functionality of a user track
class UserTrack
  class External
    extend Mandate::Memoize
    attr_reader :track

    def initialize(track)
      @track = track
    end

    delegate :concepts, :num_exercises, :num_concepts, :updated_at, :course?,
      to: :track
    delegate :title, to: :track, prefix: true

    def user = nil
    def tutorial_exercise_completed? = false
    def anonymous_during_mentoring? = true

    def solutions = Solution.none

    memoize
    def exercises = track.available_exercises.published

    memoize
    def concept_exercises = track.available_concept_exercises.published

    memoize
    def practice_exercises = track.available_practice_exercises.published

    def concept_exercises_for_concept(concept) = concept.concept_exercises.published
    def practice_exercises_for_concept(concept) = concept.practice_exercises.published
    def unlocked_concepts_for_exercise(exercise) = exercise.unlocked_concepts
    def unlocked_exercises_for_exercise(exercise) = exercise.unlocked_exercises.published

    #######################
    # Non-summary methods #
    #######################
    def external? = true
    def practice_mode? = false
    def last_touched_at = nil

    memoize
    def concept_slugs
      concepts.map(&:slug)
    end

    def learnt_concepts
      []
    end

    def objectives = nil

    def exercise_type(obj)
      return obj.git_type if obj.is_a?(Exercise)

      exercise_types[obj]
    end

    memoize
    def exercise_types
      track.exercises.select(:slug, :type).index_by(&:slug).transform_values(&:git_type)
    end

    memoize
    def exercise_positions
      track.exercises.pluck(:slug, :position).index_by(&:first)
    end

    ####################
    # Exercise methods #
    ####################
    def exercise_unlocked?(_) = true
    def exercise_completed?(_) = false

    def exercise_status(_) = :external
    def exercise_has_notifications?(_) = false

    def exercise_position(slug)
      exercise_positions[slug]
    end

    ###############################
    # Exercises aggregate methods #
    ###############################

    def num_completed_exercises = 0

    def unlocked_exercise_ids
      []
    end

    ###################
    # Concept methods #
    ###################
    def concept_unlocked?(_) = false
    def concept_learnt?(_) = false
    def concept_mastered?(_) = false

    def num_exercises_for_concept(obj)
      obj.is_a?(Concept) ? slug = obj.slug : slug = obj.to_s
      concept_exercises_counts[slug]
    end

    def num_completed_exercises_for_concept(_) = 0

    #############################
    # Concept aggregate methods #
    #############################
    def unlocked_concept_ids
      []
    end

    def num_concepts_learnt = 0
    def num_concepts_mastered = 0

    ###################
    # Private methods #
    ###################
    private
    memoize
    def concept_exercises_counts
      taught_counts = Exercise::TaughtConcept.
        joins(:exercise, :concept).
        where('exercises.track_id': track.id).
        group('track_concepts.slug').
        count

      practice_counts = Exercise::Prerequisite.
        joins(:exercise, :concept).
        where('exercises.track_id': track.id).
        where('exercises.type': "PracticeExercise").
        group('track_concepts.slug').
        count

      # Sum the counts
      taught_counts.merge(practice_counts) { |_, t, p| t + p }
    end
  end
end
