defmodule Bullet.Journal do
  @moduledoc """
  The Journal context.
  """

  alias Bullet.Journal.Goal
  alias Bullet.Journal.GoalRecord

  @doc """
  Returns the list of goals.

  ## Examples

      iex> list_goals()
      [%Goal{}, ...]

  """
  @spec list_goals() :: [Goal.t()]
  def list_goals do
    Goal.get_all()
  end

  @doc """
  Gets a single goal.

  Raises if the Goal does not exist.

  ## Examples

      iex> get_goal!(123)
      %Goal{}

  """
  @spec get_goal!(String.t() | integer) :: Goal.t()
  def get_goal!(id) when is_binary(id), do: get_goal!(String.to_integer(id))
  def get_goal!(id) when is_integer(id), do: Goal.get!(id)

  @doc """
  Creates a goal.

  ## Examples

      iex> create_goal(%{field: value})
      {:ok, %Goal{}}

      iex> create_goal(%{field: bad_value})
      {:error, ...}

  """
  @spec create_goal(map()) :: {:ok, Goal.t()} | {:error, Ecto.Changeset.t()}
  def create_goal(attrs \\ %{}) do
    attrs =
      attrs
      |> Map.put(:id, System.unique_integer([:positive, :monotonic]))

    %Goal{}
    |> Goal.changeset(attrs)
    |> Goal.create()
  end

  @doc """
  Updates a goal.

  ## Examples

      iex> update_goal(goal, %{field: new_value})
      {:ok, %Goal{}}

      iex> update_goal(goal, %{field: bad_value})
      {:error, ...}

  """
  @spec update_goal(Goal.t(), map()) :: {:ok, Goal.t()} | {:error, Ecto.Changeset.t()}
  def update_goal(%Goal{} = goal, attrs) do
    goal
    |> Goal.changeset(attrs)
    |> Goal.create()
  end

  @doc """
  Deletes a Goal.

  ## Examples

      iex> delete_goal(goal)
      {:ok, %Goal{}}

      iex> delete_goal(goal)
      {:error, ...}

  """
  @spec delete_goal(Goal.t()) :: {:ok, Goal.t()} | {:error, Ecto.Changeset.t()}
  def delete_goal(%Goal{} = _goal) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking goal changes.

  ## Examples

      iex> change_goal(goal)
      %Todo{...}

  """
  @spec change_goal(Goal.t(), map()) :: Ecto.Changeset.t()
  def change_goal(%Goal{} = goal, attrs \\ %{}) do
    Goal.changeset(goal, attrs)
  end

  @spec list_goal_records() :: [GoalRecord.t()]
  def list_goal_records do
    GoalRecord.get_all()
  end

  @spec create_goal_record(map()) :: {:ok, GoalRecord.t()} | {:error, Ecto.Changeset.t()}
  def create_goal_record(attrs \\ %{}) do
    attrs =
      attrs
      |> Map.put(:id, System.unique_integer([:positive, :monotonic]))

    %GoalRecord{}
    |> GoalRecord.changeset(attrs)
    |> GoalRecord.create()
  end

  @spec get_goal_record!(String.t() | integer) :: GoalRecord.t()
  def get_goal_record!(id) when is_binary(id), do: get_goal_record!(String.to_integer(id))
  def get_goal_record!(id) when is_integer(id), do: GoalRecord.get!(id)

  @spec delete_goal_record(GoalRecord.t()) :: {:ok, GoalRecord.t()} | {:error, Ecto.Changeset.t()}
  def delete_goal_record(%GoalRecord{} = _goal_record) do
    raise "TODO"
  end
end
