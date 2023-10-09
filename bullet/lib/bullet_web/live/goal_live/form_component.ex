defmodule BulletWeb.GoalLive.FormComponent do
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

      <.simple_form
        for={@form}
        id="goal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:description]} type="text" label="Description" required />
        <.input
          field={@form[:goal_type]}
          type="select"
          label="Goal Type"
          options={["Yes/No Goal": :yesno_goal, "Numeric Goal": :numeric_goal]}
          required
        />

        <%= if assigns[:numeric_goal_type] do %>
          <.input field={@form[:target_unit]} type="number" label="Target Unit" value="" />
        <% else %>
          <.input field={@form[:target_unit]} type="hidden" value="1" />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{goal: goal} = assigns, socket) do
    changeset = Journal.change_goal(goal)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"goal" => goal_params}, socket) do
    changeset =
      socket.assigns.goal
      |> Journal.change_goal(goal_params)

    # |> Map.put(action: "validate")

    {:noreply, socket |> maybe_show_numeric_goal(goal_params) |> assign_form(changeset)}
  end

  def handle_event("save", %{"goal" => goal_params}, socket) do
    save_goal(socket, socket.assigns.action, goal_params)
  end

  defp save_goal(socket, :edit, goal_params) do
    case Journal.update_goal(socket.assigns.goal, goal_params) do
      {:ok, goal} ->
        IO.inspect("can update", label: "save_goal edit ok")
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, "Goal updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "save_goal edit error")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_goal(socket, :new, goal_params) do
    case Journal.create_goal(goal_params) do
      {:ok, goal} ->
        IO.inspect("can create", label: "save_goal new ok")
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, "Goal created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "save_goal new error")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp maybe_show_numeric_goal(socket, %{"goal_type" => goal_type}) do
    socket =
      case String.to_existing_atom(goal_type) do
        :numeric_goal -> socket |> assign(:numeric_goal_type, true)
        _ -> socket |> assign(:numeric_goal_type, false)
      end

    socket
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    IO.inspect(changeset, label: "assign_form")
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
