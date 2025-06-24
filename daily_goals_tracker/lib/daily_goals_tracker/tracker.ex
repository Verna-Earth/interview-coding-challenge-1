defmodule DailyGoalsTracker.Tracker do
  @moduledoc """
  The Tracker context.
  """

  import Ecto.Query, warn: false
  import DailyGoalsTracker.Helpers, only: [as_percentage: 2]

  alias Ecto.Changeset

  alias DailyGoalsTracker.Store
  alias DailyGoalsTracker.Tracker.{Goal, Achievement, WeekStats}

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

  def get_goal_achievements(%Goal{} = goal), do: Store.list_by(%{goal_id: goal.id}, :achievements)

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

  # def get_goal_achievements(%Goal{} = goal), do: Store.list_by(%{goal_id: goal.id}, :achievements)

  def list_achievements(%Date{} = date) do
    Store.list_by(%{day: date}, :achievements)
  end

  def get_achievement(id), do: Store.get(id, :achievements)

  def create_or_update_achievement(%Achievement{} = achievement, attrs \\ %{}) do
    achievement
    |> Achievement.changeset(attrs)
    |> Changeset.apply_changes()
    |> then(fn
      %{id: nil} = achievement -> Store.create(achievement, :achievements)
      achievement -> Store.update(achievement, :achievements)
    end)
  end

  def create_achievement(attrs \\ %{}) do
    %Achievement{}
    |> Achievement.changeset(attrs)
    |> Changeset.apply_changes()
    |> Store.create(:achievements)
  end

  def update_achievement(%Achievement{} = achievement, attrs) do
    achievement
    |> Achievement.changeset(attrs)
    |> Changeset.apply_changes()
    |> Store.update(:achievements)
  end

  def remove_achievement(%Achievement{} = achievement) do
    Store.delete(achievement, :achievements)
  end

  def change_achievement(%Achievement{} = achievement, attrs \\ %{}) do
    Achievement.changeset(achievement, attrs)
  end

  def get_goals_with_achievements(%Date{} = date) do
    goals = list_goals()
    achievements = Store.list_by(%{day: date}, :achievements) || []

    Enum.map(goals, fn goal ->
      %{goal | achievement: get_or_build_achievement(achievements, goal, date)}
    end)
  end

  def get_goal_weekly_stats(goal_id) do
    goal = get_goal(goal_id)

    %{goal_id: goal_id}
    |> Store.list_by(:achievements)
    |> Enum.group_by(&date_week_number(&1.day))
    |> Enum.map(fn {{year, week}, [first | _rest] = achievements} ->
      days_recored = Enum.filter(achievements, &(&1.progress > 0)) |> length()
      total_recored = Enum.sum_by(achievements, & &1.progress)

      %WeekStats{
        id: "#{year}-#{week}",
        week: week,
        from: Date.beginning_of_week(first.day),
        to: Date.end_of_week(first.day),
        number_of_days_recored: days_recored,
        total_recored: total_recored,
        total_percentage_achieved: as_percentage(total_recored, goal.target * 7),
        average_recored: Float.floor(total_recored / 7, 2),
        average_percentage_achieved: as_percentage(Float.floor(total_recored / 7, 2), goal.target)
      }
    end)
    |> Enum.sort_by(& &1.week, :desc)
  end

  defp get_or_build_achievement(achievements, %Goal{id: goal_id}, selected_date) do
    Enum.find(achievements, &(&1.goal_id == goal_id)) || Achievement.build(goal_id, selected_date)
  end

  def date_week_number(%Date{} = date) do
    date |> Date.to_erl() |> :calendar.iso_week_number()
  end
end
