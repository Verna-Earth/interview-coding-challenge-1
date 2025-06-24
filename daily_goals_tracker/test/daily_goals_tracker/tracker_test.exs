defmodule DailyGoalsTracker.TrackerTest do
  use DailyGoalsTracker.DataCase, async: false

  alias DailyGoalsTracker.Tracker
  alias DailyGoalsTracker.Tracker.{Goal, Achievement}

  alias DailyGoalsTracker.TrackerFactory, as: TF

  describe "goals" do
    test "list_goals/0 returns all goals" do
      assert {:ok, goal} = TF.params_for(:goal) |> Tracker.create_goal()
      assert Tracker.list_goals() == [goal]
    end

    test "get_goal/1 returns the goal with given id" do
      assert {:ok, goal} = TF.params_for(:goal) |> Tracker.create_goal()
      assert Tracker.get_goal(goal.id) == goal
    end

    test "create_goal/1 with valid binary type creates a goal" do
      valid_attrs = TF.params_for(:goal, type: :binary, target: 1)

      assert {:ok, %Goal{} = goal} = Tracker.create_goal(valid_attrs)
      assert is_integer(goal.id)
      assert goal.type == :binary
      assert goal.target == 1
      assert is_struct(goal.inserted_at, DateTime)
    end

    test "create_goal/1 with missing data returns error changeset" do
      invalid_attrs = TF.params_for(:goal, type: nil, target: nil)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  type: {"can't be blank", [validation: :required]},
                  target: {"can't be blank", [validation: :required]}
                ]
              }} = Tracker.create_goal(invalid_attrs)
    end

    test "create_goal/1 with invalid target for type: binary returns error changeset" do
      invalid_attrs = TF.params_for(:goal, type: :binary, target: 2)

      assert {:error,
              %Ecto.Changeset{
                errors: [target: {"cannot be greater than 1 when type is binary", []}]
              }} = Tracker.create_goal(invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      assert {:ok, goal} =
               TF.params_for(:goal, name: "New goal", type: :binary, target: 1)
               |> Tracker.create_goal()

      update_attrs = %{name: "Updated goal"}

      assert {:ok, %Goal{} = goal} = Tracker.update_goal(goal, update_attrs)
      assert goal.name == "Updated goal"
    end

    test "update_goal/2 with invalid data returns error changeset" do
      assert {:ok, goal} =
               TF.params_for(:goal, type: :binary, target: 1)
               |> Tracker.create_goal()

      invalid_attrs = %{target: 2}

      assert {:error, %Ecto.Changeset{}} = Tracker.update_goal(goal, invalid_attrs)
      assert goal == Tracker.get_goal(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      assert {:ok, goal} = TF.params_for(:goal, target: 1) |> Tracker.create_goal()

      assert {:ok, %Goal{}} = Tracker.delete_goal(goal)
      assert is_nil(Tracker.get_goal(goal.id))
    end

    test "change_goal/1 returns a goal changeset" do
      assert {:ok, goal} = TF.params_for(:goal, target: 1) |> Tracker.create_goal()
      assert %Ecto.Changeset{} = Tracker.change_goal(goal)
    end
  end

  describe "get_goals_with_achievements/1" do
    test "when goal has no achievement returns goal with an achievement that has no progress" do
      assert {:ok, goal} = TF.params_for(:goal, target: 1) |> Tracker.create_goal()
      %Goal{id: goal_id, name: goal_name} = goal
      today = Date.utc_today()

      assert [
               %Goal{
                 name: ^goal_name,
                 achievement: %Achievement{id: nil, goal_id: ^goal_id, day: ^today, progress: 0}
               }
             ] = Tracker.get_goals_with_achievements(today)
    end

    test "return goal with progress" do
      assert {:ok, goal} =
               TF.params_for(:goal, type: :numeric, target: 10) |> Tracker.create_goal()

      %Goal{id: goal_id, name: goal_name} = goal

      assert {:ok, _achievement} =
               TF.params_for(:achievement, goal_id: goal.id, progress: 5)
               |> Tracker.create_achievement()

      today = Date.utc_today()

      assert [
               %Goal{
                 id: ^goal_id,
                 name: ^goal_name,
                 achievement: %Achievement{
                   id: achievement_id,
                   goal_id: ^goal_id,
                   day: ^today,
                   progress: 5
                 }
               }
             ] = Tracker.get_goals_with_achievements(today)

      assert is_integer(achievement_id)
    end
  end
end
