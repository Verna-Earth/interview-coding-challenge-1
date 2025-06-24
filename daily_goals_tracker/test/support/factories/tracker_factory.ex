defmodule DailyGoalsTracker.TrackerFactory do
  use ExMachina.Ecto

  alias DailyGoalsTracker.Fake
  alias DailyGoalsTracker.Tracker.{Goal, Achievement}

  def goal_factory(attrs) do
    %Goal{
      id: Map.get(attrs, :id, Fake.id()),
      name: Map.get(attrs, :name, Fake.goal_name()),
      type: Map.get(attrs, :type, Fake.goal_type()),
      target: Map.get(attrs, :target, 1),
      inserted_at: Map.get(attrs, :inserted_at, DateTime.utc_now()),
      updated_at: Map.get(attrs, :updated_at)
    }
  end

  def achievement_factory(attrs) do
    %Achievement{
      id: Map.get(attrs, :id, Fake.id()),
      day: Map.get(attrs, :day, Date.utc_today()),
      goal_id: Map.get(attrs, :goal_id, Fake.id()),
      progress: Map.get(attrs, :progress, 0),
      inserted_at: Map.get(attrs, :inserted_at, DateTime.utc_now()),
      updated_at: Map.get(attrs, :updated_at)
    }
  end
end
