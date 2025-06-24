defmodule DailyGoalsTrackerWeb.ReportLive.Index do
  use DailyGoalsTrackerWeb, :live_view
  import DailyGoalsTrackerWeb.ReportLive.Components

  alias DailyGoalsTracker.Tracker
  # alias DailyGoalsTracker.Tracker.Goal

  @impl true
  def mount(_params, _session, socket) do
    goal_names = Tracker.list_goals() |> Enum.map(&{&1.name, &1.id})
    form = to_form(%{"goal" => nil})
    {:ok, assign(socket, form: form, goal_names: goal_names)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Achievement Reports")
    |> assign(:goal, nil)
  end

  @impl true
  def handle_event("selected-goal", %{"goal" => goal_id}, socket) do
    goal = Tracker.get_goal(String.to_integer(goal_id))
    stats = Tracker.get_goal_weekly_stats(String.to_integer(goal_id))
    new_socket = socket |> stream(:stats, stats) |> assign(:goal, goal)
    {:noreply, new_socket}
  end
end
