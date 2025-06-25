defmodule DailyGoalsTracker.TrackerTest do
  use DailyGoalsTracker.DataCase, async: false

  alias DailyGoalsTracker.Tracker
  alias DailyGoalsTracker.Tracker.{Goal, Achievement, WeekStats}

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

  describe "achievements" do
    test "get_goals_with_achievements/1 when goal has no achievement returns goal with an achievement that has no progress" do
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

    test "get_goals_with_achievements/1 returns goal with progress" do
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

    test "get_achievement/1 returns the achievement with given id" do
      assert {:ok, achievement} = TF.params_for(:achievement) |> Tracker.create_achievement()
      assert Tracker.get_achievement(achievement.id) == achievement
    end

    test "create_achievement/1 creates a achievement" do
      valid_attrs = TF.params_for(:achievement, progress: 10)

      assert {:ok, %Achievement{} = achievement} = Tracker.create_achievement(valid_attrs)
      assert is_integer(achievement.id)
      assert is_integer(achievement.goal_id)
      assert achievement.progress == 10
      assert is_struct(achievement.day, Date)
      assert is_struct(achievement.inserted_at, DateTime)
    end

    test "create_or_update_achievement/2 creates a achievement" do
      valid_attrs = TF.params_for(:achievement, progress: 10)

      assert {:ok, %Achievement{} = achievement} =
               Tracker.create_or_update_achievement(%Achievement{}, valid_attrs)

      assert is_integer(achievement.id)
      assert is_integer(achievement.goal_id)
      assert achievement.progress == 10
      assert is_struct(achievement.day, Date)
      assert is_struct(achievement.inserted_at, DateTime)
    end

    test "create_or_update_achievement/2 updates a achievement" do
      assert {:ok, %Achievement{} = achievement} =
               Tracker.create_or_update_achievement(
                 %Achievement{id: 100, goal_id: 10, day: Date.utc_today()},
                 %{progress: 10}
               )

      assert achievement.id == 100
      assert achievement.goal_id == 10
      assert achievement.progress == 10
      assert is_struct(achievement.day, Date)
    end

    test "update_achievement/2 updates a achievement" do
      assert {:ok, achievement} =
               TF.params_for(:achievement, progress: 10) |> Tracker.create_achievement()

      assert {:ok, %Achievement{} = achievement} =
               Tracker.update_achievement(achievement, %{progress: 20})

      assert is_integer(achievement.id)
      assert is_integer(achievement.goal_id)
      assert achievement.progress == 20
      assert is_struct(achievement.day, Date)
      assert is_struct(achievement.inserted_at, DateTime)
    end

    test "change_achievement/1 returns a achievement changeset" do
      assert {:ok, achievement} =
               TF.params_for(:achievement, progress: 10) |> Tracker.create_achievement()

      assert %Ecto.Changeset{} = Tracker.change_achievement(achievement)
    end

    test "get_goal_weekly_stats/1 returns stats for the last 15 days" do
      today = Date.utc_today()

      this_week_number =
        today
        |> Date.beginning_of_week()
        |> Date.to_erl()
        |> :calendar.iso_week_number()
        |> elem(1)

      last_week_number =
        today
        |> Date.beginning_of_week()
        |> Date.add(-7)
        |> Date.to_erl()
        |> :calendar.iso_week_number()
        |> elem(1)

      two_weeks_ago_number =
        today
        |> Date.beginning_of_week()
        |> Date.add(-14)
        |> Date.to_erl()
        |> :calendar.iso_week_number()
        |> elem(1)

      assert {:ok, goal} =
               TF.params_for(:goal, name: "Goal one", type: :numeric, target: 100)
               |> Tracker.create_goal()

      for day_offset <- -0..-15//-1 do
        assert {:ok, _achievement} =
                 TF.params_for(:achievement,
                   goal_id: goal.id,
                   progress: 50,
                   day: Date.add(today, day_offset)
                 )
                 |> Tracker.create_achievement()
      end

      assert [
               %WeekStats{week: ^this_week_number},
               %WeekStats{week: ^last_week_number},
               %WeekStats{week: ^two_weeks_ago_number}
             ] = Tracker.get_goal_weekly_stats(goal.id)
    end
  end
end
