defmodule DailyGoalsTracker.Seeder do
  alias DailyGoalsTracker.Tracker.Goal

  def seed do
    goals = [
      %Goal{
        id: 1,
        name: "Golal 1",
        type: :numeric,
        target: 10,
        inserted_at: DateTime.utc_now()
      },
      %Goal{
        id: 2,
        name: "Golal 2",
        type: :binary,
        target: 1,
        inserted_at: DateTime.utc_now()
      }
    ]

    %{goals: goals, progress: []}
  end
end
