defmodule BulletWeb.GoalRecordLive.Index do
  use BulletWeb, :live_view

  alias Bullet.Journal
  alias Bullet.Journal.GoalRecord
  alias Bullet.Utils

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :goal_records, Journal.list_goal_records())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :today, %{"goal_id" => goal_id}) do
    socket
    |> assign(:page_title, "New Goal Record")
    |> assign(:goal, Journal.get_goal!(goal_id))
    |> assign(:record_date, Date.utc_today())
    |> assign(:goal_record, %GoalRecord{})
  end

  defp apply_action(socket, :past, %{"goal_id" => goal_id}) do
    socket
    |> assign(:page_title, "New Goal Record")
    |> assign(:goal, Journal.get_goal!(goal_id))
    |> assign(:record_date, nil)
    |> assign(:goal_record, %GoalRecord{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Past Records")
    |> assign(:goal_record, nil)
  end

  @impl Phoenix.LiveView
  def handle_info({BulletWeb.GoalRecordLive.FormComponent, {:saved, goal_record}}, socket) do
    {:noreply, stream_insert(socket, :goal_records, goal_record, at: 0)}
  end
end
