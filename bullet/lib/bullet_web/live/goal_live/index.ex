defmodule BulletWeb.GoalLive.Index do
  use BulletWeb, :live_view

  alias Bullet.Journal
  alias Bullet.Journal.Goal

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :goals, Journal.list_goals())}
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
    {:noreply, stream_insert(socket, :goals, goal)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    goal = Journal.get_goal!(id)
    {:ok, _} = Journal.delete_goal(goal)

    {:noreply, stream_delete(socket, :goals, goal)}
  end
end
