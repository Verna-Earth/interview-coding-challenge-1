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
        target_unit: 0,
        goal_type: :numeric_goal
      })
      |> Bullet.Journal.create_goal()

    goal
  end
end
