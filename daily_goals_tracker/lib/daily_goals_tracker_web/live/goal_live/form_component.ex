defmodule DailyGoalsTrackerWeb.GoalLive.FormComponent do
  use DailyGoalsTrackerWeb, :live_component

  alias DailyGoalsTracker.Tracker

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage goal records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="goal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          prompt="<-- select -->"
          options={[{"Yes/No", :binary}, {"Numerical", :numeric}]}
          phx-target={@myself}
          phx-change="select-type"
        />

        <.input :if={@selected_type == :numeric} field={@form[:target]} type="number" label="Target" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Goal</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{goal: goal} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:selected_type, goal.type)
     |> assign_new(:form, fn ->
       to_form(Tracker.change_goal(goal))
     end)}
  end

  @impl true
  def handle_event("validate", %{"goal" => goal_params}, socket) do
    changeset = Tracker.change_goal(socket.assigns.goal, goal_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("select-type", %{"goal" => %{"type" => type}}, socket) do
    {:noreply, assign(socket, selected_type: String.to_atom(type))}
  end

  def handle_event("save", %{"goal" => %{"type" => "binary"} = goal_params}, socket) do
    save_goal(socket, socket.assigns.action, Map.put(goal_params, "target", "1"))
  end

  def handle_event("save", %{"goal" => goal_params}, socket) do
    save_goal(socket, socket.assigns.action, goal_params)
  end

  defp save_goal(socket, :edit, goal_params) do
    case Tracker.update_goal(socket.assigns.goal, goal_params) do
      {:ok, goal} ->
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, "Goal updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_goal(socket, :new, goal_params) do
    case Tracker.create_goal(goal_params) do
      {:ok, goal} ->
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, "Goal created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
