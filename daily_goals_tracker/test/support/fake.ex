defmodule DailyGoalsTracker.Fake do
  import ExMachina, only: [sequence: 2]

  alias DailyGoalsTracker.Tracker.Goal

  def id, do: sequence(:id, &(&1 + 1))
  def goal_name, do: sequence(:goal_name, &"Fake goal name #{&1}")
  def goal_type, do: Ecto.Enum.values(Goal, :type) |> Enum.random()
end
