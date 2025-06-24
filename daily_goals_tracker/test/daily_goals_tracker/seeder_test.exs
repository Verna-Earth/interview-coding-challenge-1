defmodule DailyGoalsTracker.SeederTest do
  use DailyGoalsTracker.DataCase, async: true

  alias DailyGoalsTracker.Seeder
  alias DailyGoalsTracker.Tracker.{Goal, Achievement}

  test "it should build the seed" do
    assert %{goals: goals, achievements: achievements} = Seeder.seed()

    assert Enum.all?(goals, &is_struct(&1, Goal))
    assert Enum.all?(achievements, &is_struct(&1, Achievement))
  end
end
