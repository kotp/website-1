require 'test_helper'

class SerializeExerciseRepresentationTest < ActiveSupport::TestCase
  test "serialize representation" do
    last_submitted_at = Time.zone.now - 2.days
    track = create :track, title: 'Ruby'
    exercise = create :practice_exercise, title: 'Bob', track: track
    representation = create :exercise_representation, id: 3, feedback_markdown: 'Yay', exercise: exercise, num_submissions: 5,
      last_submitted_at: last_submitted_at

    expected = {
      id: 3,
      exercise: {
        icon_url: 'https://exercism-v3-icons.s3.eu-west-2.amazonaws.com/exercises/bob.svg',
        title: 'Bob'
      },
      track: {
        icon_url: 'https://exercism-v3-icons.s3.eu-west-2.amazonaws.com/tracks/ruby.svg',
        title: 'Ruby'
      },
      num_submissions: 5,
      appears_frequently: true,
      feedback_markdown: "Yay",
      last_submitted_at:,
      links: {
        edit: '/mentoring/automation/3/edit'
      }
    }

    assert_equal expected, SerializeExerciseRepresentation.(representation)
  end
end
