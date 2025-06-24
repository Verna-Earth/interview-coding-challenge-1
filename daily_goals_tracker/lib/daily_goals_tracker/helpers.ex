defmodule DailyGoalsTracker.Helpers do
  def as_percentage(progress, target) do
    percentage = progress / target * 100
    trunked = trunc(percentage)

    if percentage == trunked do
      trunked
    else
      Float.floor(percentage, 2)
    end
  end
end
