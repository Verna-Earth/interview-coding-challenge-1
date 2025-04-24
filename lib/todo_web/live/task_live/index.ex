defmodule ToDoWeb.TaskLive.Index do
  use ToDoWeb, :live_view

  alias ToDo.Tasks
  alias ToDo.Tasks.Task

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     stream(
       socket |> assign(:user_id, session["user_id"]),
       :tasks,
       Tasks.list_tasks(session["user_id"])
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{user_id: socket.assigns.user_id, task_type: :bool, frequency: 1})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Your current tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({ToDoWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end
end
