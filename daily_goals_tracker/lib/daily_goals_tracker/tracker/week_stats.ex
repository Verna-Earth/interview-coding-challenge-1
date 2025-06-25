defmodule DailyGoalsTracker.Tracker.WeekStats do
  defstruct [
    :id,
    :week,
    :from,
    :to,
    :number_of_days_recored,
    :total_recored,
    :total_percentage_achieved,
    :average_recored,
    :average_percentage_achieved
  ]
end
