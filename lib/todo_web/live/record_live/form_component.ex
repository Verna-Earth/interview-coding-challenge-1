defmodule ToDoWeb.RecordLive.FormComponent do
  use ToDoWeb, :live_component

  alias ToDo.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
      </.header>

      <.simple_form
        for={@form}
        id="record-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          id="record-completed"
          label="Date completed"
          type="date"
          value={@form[:completed].value}
          field={@form[:completed]}
        />
        <%= if @task.task_type == :bool do %>
          <.input
            id="input-checkbox-opt1"
            label="Success?"
            name={@form[:success].name}
            field={@form[:success]}
            type="checkbox"
            value={@form[:success].value}
          />
          <input
            type="hidden"
            name={@form[:times].name}
            value={if @form[:success].value, do: 1, else: 0}
          />
        <% else %>
          <.input
            id="record-times"
            label="How many times?"
            type="number"
            value={@form[:times].value}
            field={@form[:times]}
          />
        <% end %>
        <input name={@form[:task_id].name} value={@form[:task_id].value} type="hidden" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Record</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{record: record} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tasks.change_record(record))
     end)}
  end

  @impl true
  def handle_event("validate", %{"record" => record_params}, socket) do
    changeset = Tasks.change_record(socket.assigns.record, record_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"record" => record_params}, socket) do
    save_record(socket, socket.assigns.action, record_params)
  end

  defp save_record(socket, :record_edit, record_params) do
    case Tasks.update_record(socket.assigns.record, record_params) do
      {:ok, record} ->
        notify_parent({:saved, record})

        {:noreply,
         socket
         |> put_flash(:info, "Record updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_record(socket, :record_new, record_params) do
    case Tasks.create_record(record_params) do
      {:ok, record} ->
        notify_parent({:saved, record})

        {:noreply,
         socket
         |> put_flash(:info, "Record created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
