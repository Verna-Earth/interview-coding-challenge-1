defmodule DailyGoalsTracker.Tracker.Achievement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "achievements" do
    field(:goal_id, :integer)
    field(:day, :date)
    field(:progress, :integer, default: 0)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:goal_id, :day, :progress])
    |> validate_required([:goal_id, :day])
  end

  def build(goal_id, day) do
    %__MODULE__{
      goal_id: goal_id,
      day: day
    }
  end
end
