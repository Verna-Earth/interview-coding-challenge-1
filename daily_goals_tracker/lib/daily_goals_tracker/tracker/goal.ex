defmodule DailyGoalsTracker.Tracker.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field(:name, :string)

    field(:type, Ecto.Enum, values: [:binary, :numeric])
    field(:target, :integer)
    timestamps(type: :utc_datetime)

    field(:achievement, :map, virtual: true)
  end

  @doc false
  def changeset(goal, attrs) do
    changeset =
      goal
      |> cast(attrs, [:name, :type, :target])
      |> validate_required([:name, :type, :target])

    validate_change(changeset, :target, fn :target, target ->
      if get_field(changeset, :type) == :binary && is_integer(target) && target > 1 do
        [target: "cannot be greater than 1 when type is binary"]
      else
        []
      end
    end)
  end
end
