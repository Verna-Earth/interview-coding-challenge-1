defmodule DailyGoalsTracker.Seeder do
  alias DailyGoalsTracker.Tracker.{Goal, Achievement}

  @goals [
    {"Meds taken", :binary, 1},
    {"Practise French (minutes)", :numeric, 20},
    {"Pushups", :numeric, 20},
    {"Running (km)", :numeric, 5},
    {"Cycling (minutes)", :numeric, 120},
    {"Feed the fish", :binary, 1},
    {"Phone Mun", :binary, 1},
    {"Sleep (hours)", :numeric, 8}
  ]

  def seed do
    goals = seed_goals()
    achievements = seed_achievements(goals)
    %{goals: goals, achievements: achievements}
  end

  defp seed_goals do
    for {{name, type, target}, id} <- Enum.with_index(@goals, 1) do
      %Goal{
        id: id,
        name: name,
        type: type,
        target: target,
        inserted_at: DateTime.utc_now()
      }
    end
  end

  defp seed_achievements(goals) do
    today = Date.utc_today()
    ids_ref = :counters.new(1, [])

    for day_offset <- -1..-90//-1,
        goal <- goals do
      :counters.add(ids_ref, 1, 1)

      %Achievement{
        id: :counters.get(ids_ref, 1),
        goal_id: goal.id,
        day: Date.add(today, day_offset),
        progress: calc_random_progress(goal.type, goal.target),
        inserted_at: DateTime.utc_now()
      }
    end
  end

  defp calc_random_progress(:binary, _target) do
    Enum.random([1, 1, 1, 1, 0, 0])
  end

  defp calc_random_progress(:numeric, target) do
    Enum.random(0..(target * 2))
  end
end
