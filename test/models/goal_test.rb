require "test_helper"

class GoalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "user can create new goal" do
    user = users(:one)

    new_goal = user.goals.create(
      name: "tester01's goal",
      duration: 14,
      completed: false
    )

    assert new_goal.valid?
    user.reload
    assert_includes user.goals, new_goal
  end

  test "goal belongs to user" do
    user = users(:one)

    new_goal = user.goals.create(
      name: "tester01's goal",
      duration: 14,
      completed: false
    )

    user.reload

    # Assert that the newly created goal belongs to the correct user
    assert_equal user, new_goal.user
  end

  test "user has many goals" do
    user = users(:one)
    previous_goals = user.goals.count
    goals_count = 3
    goals_count.times do |i|
      user.goals.create(
        name: "Goal #{i + 1}",
        duration: 14,
        completed: false
      )
    end

    user.reload
    # compares previous user goal count to count after loop is run

    assert_equal goals_count, user.goals.count - previous_goals
  end
end
