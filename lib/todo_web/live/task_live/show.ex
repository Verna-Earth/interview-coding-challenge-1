defmodule ToDoWeb.TaskLive.Show do
  use ToDoWeb, :live_view

  alias ToDo.Tasks

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, socket |> assign(:task, Tasks.get_task!(id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:record, nil)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show Task")
    |> assign(:task, Tasks.get_task!(id))
    |> assign(:record, nil)
  end

  defp apply_action(socket, :record_new, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add Record")
    |> assign(:record, %Tasks.Record{task_id: id})
  end

  defp apply_action(socket, :record_edit, %{"record_id" => id}) do
    socket
    |> assign(:page_title, "Edit Record")
    |> assign(:record, Tasks.get_record!(id))
  end
end
