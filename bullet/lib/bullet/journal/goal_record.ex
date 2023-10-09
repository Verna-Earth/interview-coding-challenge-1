defmodule Bullet.Journal.GoalRecord do
  @moduledoc """
  The Goal Record Entity
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bullet.Journal.Goal

  @primary_key false
  @db Bullet.CubDB
  @collection :record

  embedded_schema do
    field(:id, :integer)
    field(:record_date, :date)
    field(:completed_score, :integer)

    belongs_to(:goal, Goal, foreign_key: :goal_id)
  end

  def changeset(%__MODULE__{} = goal, attrs) do
    attrs = attrs |> Bullet.Utils.key_to_atom()

    goal
    |> cast(attrs, __schema__(:fields))
    |> validate_required(__schema__(:fields))
  end

  def get_all() do
    CubDB.select(@db, min_key: {@collection, 0}, max_key: {@collection, nil})
    |> Stream.map(fn {_key, value} ->
      value.goal_id
      struct(__MODULE__, value)
    end)
  end

  def get!(id) do
    goal_record = CubDB.get(@db, {@collection, id})

    case goal_record do
      %{id: _} -> struct(__MODULE__, goal_record)
      _ -> raise "GoalRecord not found for id #{id}"
    end
  end

  def create(%{valid?: false} = changeset), do: {:error, changeset}

  def create(%{changes: changes, valid?: true}) do
    # save to DB
    CubDB.put(@db, {@collection, changes.id}, changes)
    # read from DB and return it
    goal = CubDB.get(@db, {@collection, changes.id})
    {:ok, struct(__MODULE__, goal)}
  end
end
