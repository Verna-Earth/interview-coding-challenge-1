defmodule DailyGoalsTrackerWeb.GoalLive.Index do
  use DailyGoalsTrackerWeb, :live_view

  alias DailyGoalsTracker.Tracker
  alias DailyGoalsTracker.Tracker.Goal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :goals, Tracker.list_goals())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    goal = Tracker.get_goal(String.to_integer(id))

    socket
    |> assign(:page_title, "Edit Goal")
    |> assign(:goal, goal)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Goal")
    |> assign(:goal, %Goal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Goals")
    |> assign(:goal, nil)
  end

  @impl true
  def handle_info({DailyGoalsTrackerWeb.GoalLive.FormComponent, {:saved, goal}}, socket) do
    {:noreply, stream_insert(socket, :goals, goal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    goal = Tracker.get_goal(id)
    {:ok, _} = goal && Tracker.delete_goal(goal)

    {:noreply, stream_delete(socket, :goals, goal)}
  end

  def map_goal_type_display_value(:binary), do: "Yes/No"
  def map_goal_type_display_value(:numeric), do: "Numerical"
end
