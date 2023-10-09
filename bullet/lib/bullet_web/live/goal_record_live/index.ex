defmodule BulletWeb.GoalRecordLive.Index do
  use BulletWeb, :live_view

  alias Bullet.Journal
  alias Bullet.Journal.GoalRecord

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :goal_records, Journal.list_goal_records())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Goal Record")
    |> assign(:goal_record, Journal.get_goal_record!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Goal Record")
    |> assign(:goal_record, %GoalRecord{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Past Records")
    |> assign(:goal_record, nil)
  end

  @impl Phoenix.LiveView
  def handle_info({BulletWeb.GoalRecordLive.FormComponent, {:saved, goal_record}}, socket) do
    {:noreply, stream_insert(socket, :goal_records, goal_record)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    goal_record = Journal.get_goal_record!(id)
    {:ok, _} = Journal.delete_goal_record(goal_record)

    {:noreply, stream_delete(socket, :goal_records, goal_record)}
  end
end
