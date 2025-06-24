defmodule DailyGoalsTracker.Tracker do
  @moduledoc """
  The Tracker context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias DailyGoalsTracker.Store
  alias DailyGoalsTracker.Tracker.{Goal, Achievement}

  @doc """
  Returns the list of goals.

  ## Examples

      iex> list_goals()
      [%Goal{}, ...]

  """
  def list_goals do
    Store.list(:goals)
  end

  @doc """
  Gets a single goal.

  ## Examples

      iex> get_goal(123)
      %Goal{}

      iex> get_goal(456)
      nil

  """
  def get_goal(id), do: Store.get(id, :goals)

  @doc """
  Creates a goal.

  ## Examples

      iex> create_goal(%{field: value})
      {:ok, %Goal{}}

      iex> create_goal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_goal(attrs \\ %{}) do
    with {:ok, goal} <- Goal.changeset(%Goal{}, attrs) |> Changeset.apply_action(:insert) do
      Store.create(goal, :goals)
    end
  end

  @doc """
  Updates a goal.

  ## Examples

      iex> update_goal(goal, %{field: new_value})
      {:ok, %Goal{}}

      iex> update_goal(goal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_goal(%Goal{} = goal, attrs) do
    with {:ok, goal} <- Goal.changeset(goal, attrs) |> Changeset.apply_action(:update) do
      Store.update(goal, :goals)
    end
  end

  @doc """
  Deletes a goal.
  """
  def delete_goal(%Goal{} = goal) do
    Store.delete(goal, :goals)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking goal changes.

  ## Examples

      iex> change_goal(goal)
      %Ecto.Changeset{data: %Goal{}}

  """
  def change_goal(%Goal{} = goal, attrs \\ %{}) do
    Goal.changeset(goal, attrs)
  end

  def get_goal_achievements(%Goal{} = goal), do: Store.list_by(%{goal_id: goal.id}, :achievement)

  def list_achievements(%Date{} = date) do
    Store.list_by(%{day: date}, :achievement)
  end

  def get_achievement(id), do: Store.get(id, :achievement)

  def create_or_update_achievement(%Achievement{} = achievement, attrs \\ %{}) do
    achievement
    |> Achievement.changeset(attrs)
    |> Changeset.apply_changes()
    |> then(fn
      %{id: nil} = achievement -> Store.create(achievement, :achievement)
      achievement -> Store.update(achievement, :achievement)
    end)
  end

  def create_achievement(attrs \\ %{}) do
    %Achievement{}
    |> Achievement.changeset(attrs)
    |> Changeset.apply_changes()
    |> Store.create(:achievement)
  end

  def update_achievement(%Achievement{} = achievement, attrs) do
    achievement
    |> Achievement.changeset(attrs)
    |> Changeset.apply_changes()
    |> Store.update(:achievement)
  end

  def remove_achievement(%Achievement{} = achievement) do
    Store.delete(achievement, :achievement)
  end

  def change_achievement(%Achievement{} = achievement, attrs \\ %{}) do
    Achievement.changeset(achievement, attrs)
  end

  def get_goals_with_achievements(%Date{} = date) do
    goals = list_goals()
    achievements = Store.list_by(%{day: date}, :achievement) || []

    Enum.map(goals, fn goal ->
      %{goal | achievement: get_or_build_achievement(achievements, goal, date)}
    end)
  end

  defp get_or_build_achievement(achievements, %Goal{id: goal_id}, selected_date) do
    Enum.find(achievements, &(&1.goal_id == goal_id)) || Achievement.build(goal_id, selected_date)
  end
end
