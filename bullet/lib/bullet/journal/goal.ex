defmodule Bullet.Journal.Goal do
  @moduledoc """
  The Goal Entity
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @db Bullet.CubDB
  @collection :goal
  @max_value_uuid "ffffffff-ffff-ffff-ffff-ffffffffffff"

  embedded_schema do
    field(:id, Ecto.UUID)
    field(:description, :string)
    field(:goal_type, Ecto.Enum, values: [:yesno_goal, :numeric_goal])
    field(:target_unit, :integer)
  end

  def changeset(%__MODULE__{} = goal, attrs, opts \\ []) do
    goal
    |> cast(attrs |> Bullet.Utils.key_to_atom(), [:id, :description, :goal_type, :target_unit])
    |> validate_required([:id, :description, :goal_type])
    |> maybe_validate_target_score(opts)
  end

  defp maybe_validate_target_score(changeset, _opts) do
    if Map.get(changeset.changes, :goal_type) == :numeric_goal do
      changeset
      |> validate_required([:target_unit])
    else
      changeset
    end
  end

  def get_all() do
    CubDB.select(@db, min_key: {@collection, nil}, max_key: {@collection, @max_value_uuid})
    |> Stream.map(fn {_key, value} -> struct(__MODULE__, value) end)
  end

  def get!(id) do
    goal = CubDB.get(@db, {@collection, id})

    case goal do
      %{id: _} -> struct(__MODULE__, goal)
      _ -> raise "Goal not found for id #{id}"
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
