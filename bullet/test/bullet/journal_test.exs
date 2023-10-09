defmodule Bullet.JournalTest do
  use Bullet.DataCase

  alias Bullet.Journal

  setup do
    CubDB.clear(Bullet.CubDB)

    :ok
  end

  describe "goals" do
    alias Bullet.Journal.Goal

    import Bullet.JournalFixtures

    @invalid_attrs %{id: System.unique_integer([:positive, :monotonic]), target_unit: "abc"}

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Journal.list_goals() |> Enum.to_list() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Journal.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      valid_attrs = %{
        description: "dummy description",
        target_unit: 10,
        goal_type: :numeric_goal
      }

      assert {:ok, %Goal{} = goal} = Journal.create_goal(valid_attrs)
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journal.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()

      update_attrs = %{
        id: System.unique_integer([:positive, :monotonic]),
        description: "Dummy descriptions",
        target_unit: 100,
        goal_type: :yesno_goal
      }

      assert {:ok, %Goal{} = goal} = Journal.update_goal(goal, update_attrs)
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Journal.update_goal(goal, @invalid_attrs)
      assert goal == Journal.get_goal!(goal.id)
    end

    # test "delete_goal/1 deletes the goal" do
    #   goal = goal_fixture()
    #   assert {:ok, %Goal{}} = Journal.delete_goal(goal)
    #   assert_raise Ecto.NoResultsError, fn -> Journal.get_goal!(goal.id) end
    # end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Journal.change_goal(goal)
    end
  end
end
