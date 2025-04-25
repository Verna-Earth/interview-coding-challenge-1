defmodule ToDoWeb.RecordLive.TableComponent do
  use ToDoWeb, :live_component

  attr :records, :list, required: true, doc: "The list of records associated with the task"
  attr :task, :any, required: true, doc: "The task, for where we need the id etc"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.subheader class="text-base">
        How it's going
        <:actions>
          <.link patch={~p"/tasks/#{@task.id}/records/new"}>
            <.button>New record</.button>
          </.link>
        </:actions>
      </.subheader>
      <.table id="records" rows={@records}>
        <:col :let={record} label="Date">{record.completed}</:col>
        <:col :let={record} label="Result?">
          <%= if @task.task_type == :bool do %>
            <%= if record.times == 1 do %>
              Yes
            <% else %>
              No
            <% end %>
          <% else %>
            {record.times}x
          <% end %>
        </:col>
        <:action :let={record}>
          <.link patch={~p"/tasks/#{@task.id}/records/#{record}/edit"}>Edit</.link>
        </:action>
        <:action :let={record}>
          <.link
            phx-click={JS.push("delete", value: %{id: record.id}) |> hide("##{record.id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
      <.modal
        :if={@action in [:record_new, :record_edit]}
        id="task-modal"
        show
        on_cancel={JS.patch(~p"/tasks/#{@task}")}
      >
        <.live_component
          module={ToDoWeb.RecordLive.FormComponent}
          id={@task.id}
          page_title={@page_title}
          action={@action}
          task={@task}
          record={@record}
          patch={~p"/tasks/#{@task}"}
        />
      </.modal>
    </div>
    """
  end
end
