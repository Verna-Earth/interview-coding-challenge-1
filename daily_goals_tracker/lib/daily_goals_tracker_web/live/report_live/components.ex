defmodule DailyGoalsTrackerWeb.ReportLive.Components do
  use Phoenix.Component
  use DailyGoalsTrackerWeb, :live_component

  def goal_selector(assigns) do
    ~H"""
    <div>
      <.form :let={f} id="goal-selector" for={@form} phx-change="goal-selected">
        <div class="mt-10 space-y-8 bg-white">
          <.input
            field={f[:goal]}
            type="select"
            label="Select to see progress report"
            prompt="<-- select -->"
            options={@goal_names}
            phx-change="selected-goal"
          />
        </div>
      </.form>
    </div>
    """
  end
end
