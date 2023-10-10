defmodule BulletWeb.GoalLive.Index do
  use BulletWeb, :live_view

  alias Bullet.Journal
  alias Bullet.Journal.Goal
  alias Bullet.Utils

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:goals, Journal.list_goals())
      |> assign(:today_goal_records, Journal.list_todays_goal_records() |> Enum.to_list())

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Goal")
    |> assign(:goal, Journal.get_goal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Goal")
    |> assign(:goal, %Goal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Today's Goals")
    |> assign(:goal, nil)
  end

  @impl Phoenix.LiveView
  def handle_info({BulletWeb.GoalLive.FormComponent, {:saved, goal}}, socket) do
    {:noreply, stream_insert(socket, :goals, goal, at: 0)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    goal = Journal.get_goal!(id)
    {:ok, _} = Journal.delete_goal(goal)

    {:noreply, stream_delete(socket, :goals, goal)}
  end

  defp goal_complete?(goal, goal_records) do
    goal_records
    |> Enum.any?(fn gr ->
      gr.goal_id == goal.id and gr.completed_score >= goal.target_unit
    end)
  end

  defp get_goal_complete(goal, goal_records) do
    case Enum.find(goal_records, fn gr -> gr.goal_id == goal.id end) do
      nil -> ""
      goal_record -> Utils.get_percentage_string(goal_record.completed_score, goal.target_unit)
    end
  end
end
