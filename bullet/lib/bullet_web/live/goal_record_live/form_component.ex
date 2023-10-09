defmodule BulletWeb.GoalRecordLive.FormComponent do
  use BulletWeb, :live_component

  alias Bullet.Journal

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <%!-- <:subtitle>Use this form to manage goal.</:subtitle> --%>
      </.header>

      <h3 class="text-gray-900">Description</h3>
      <h3 class="text-sm text-gray-700">
        <%= @goal.description %>
      </h3>
      <h3 class="text-gray-900">Target Unit</h3>
      <h3 class="text-sm text-gray-700">
        <%= @goal.target_unit %>
      </h3>

      <.simple_form
        for={@form}
        id="goal-record-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          :if={!is_nil(assigns[:record_date])}
          field={@form[:record_date]}
          type="text"
          label="Record Date (YYYY-MM-DD)"
          value={@record_date}
          required
          readonly
        />
        <.input
          :if={is_nil(assigns[:record_date])}
          field={@form[:record_date]}
          type="text"
          label="Record Date (YYYY-MM-DD)"
          required
        />

        <%= if @goal.goal_type == :numeric_goal do %>
          <.input
            field={@form[:completed_score]}
            type="number"
            label="Completed Score"
            value=""
            required
          />
        <% else %>
          <.input field={@form[:completed_score]} type="hidden" value="1" />
        <% end %>
        <.input field={@form[:goal_id]} type="hidden" value={@goal.id} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Complete</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{goal_record: goal_record} = assigns, socket) do
    changeset = Journal.change_goal_record(goal_record)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"goal_record" => goal_record_params}, socket) do
    changeset =
      socket.assigns.goal_record
      |> Journal.change_goal_record(goal_record_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign_form(changeset)}
  end

  def handle_event("save", %{"goal_record" => goal_record_params}, socket) do
    save_goal_record(socket, socket.assigns.action, goal_record_params)
  end

  defp save_goal_record(socket, :edit, goal_record_params) do
    case Journal.update_goal_record(socket.assigns.goal_record, goal_record_params) do
      {:ok, goal_record} ->
        notify_parent({:saved, goal_record})

        {:noreply,
         socket
         |> put_flash(:info, "Goal Record updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_goal_record(socket, :today, goal_record_params),
    do: save_goal_record(socket, :new, goal_record_params)

  defp save_goal_record(socket, :past, goal_record_params),
    do: save_goal_record(socket, :new, goal_record_params)

  defp save_goal_record(socket, :new, goal_record_params) do
    case Journal.create_goal_record(goal_record_params) do
      {:ok, goal_record} ->
        notify_parent({:saved, goal_record})

        {:noreply,
         socket
         |> put_flash(:info, "Goal Record created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
