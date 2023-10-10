defmodule Bullet.JournalFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bullet.Journal` context.
  """

  @doc """
  Generate a goal.
  """
  def goal_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> Enum.into(%{
        description: "default goal description",
        target_unit: 10,
        goal_type: :numeric_goal
      })
      |> Bullet.Journal.create_goal()

    goal
  end

  @doc """
  Generate a goal record.
  """
  def goal_record_fixture(attrs \\ %{}) do
    goal = goal_fixture()
    {:ok, goal_record} =
      attrs
      |> Enum.into(%{
        record_date: Date.utc_today(),
        completed_score: 2,
        goal_id: goal.id
      })
      |> Bullet.Journal.create_goal_record()

    goal_record
  end
end
