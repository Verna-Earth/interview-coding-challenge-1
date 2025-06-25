defmodule DailyGoalsTrackerWeb.AchievementLive.Index do
  use DailyGoalsTrackerWeb, :live_view
  import DailyGoalsTracker.Helpers, only: [as_percentage: 2]

  alias DailyGoalsTracker.Tracker

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, params) when map_size(params) == 0 do
    selected_date = Date.utc_today()
    push_patch(socket, to: ~p"/achievements/#{Date.to_iso8601(selected_date)}")
  end

  defp apply_action(socket, :show, %{"day" => day}) do
    case Date.from_iso8601(day) do
      {:ok, selected_date} ->
        goals = Tracker.get_goals_with_achievements(selected_date)

        socket
        |> assign(:selected_date, selected_date)
        |> stream(:goals, goals)

      _error ->
        selected_date = Date.utc_today()

        socket
        |> put_flash(:error, "Invalid date")
        |> push_patch(to: ~p"/achievements/#{Date.to_iso8601(selected_date)}")
    end
  end

  @impl true
  def handle_info({DailyGoalsTrackerWeb.AchievementLive.FormComponent, {:saved, goal}}, socket) do
    {:noreply, stream_insert(socket, :goals, goal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    goal = Tracker.get_goal(id)
    {:ok, _} = goal && Tracker.delete_goal(goal)

    {:noreply, stream_delete(socket, :goals, goal)}
  end

  def fmt_date(%Date{} = date) do
    cond do
      date == Date.utc_today() ->
        "Today's"

      date == Date.utc_today() |> Date.add(-1) ->
        "Yesterday's"

      date ->
        Calendar.strftime(date, "%a, %b %d %Y")
    end
  end

  def previous_day(%Date{} = date) do
    date |> Date.add(-1) |> Date.to_iso8601()
  end

  def next_day(%Date{} = date) do
    if date != Date.utc_today() do
      date |> Date.add(1) |> Date.to_iso8601()
    else
      nil
    end
  end
end
