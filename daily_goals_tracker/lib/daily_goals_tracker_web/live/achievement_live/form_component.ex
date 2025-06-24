defmodule DailyGoalsTrackerWeb.AchievementLive.FormComponent do
  use DailyGoalsTrackerWeb, :live_component

  alias DailyGoalsTracker.Tracker

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        :let={f}
        id={"goal-#{@goal.id}-achievement-form"}
        for={@form}
        phx-change="update-achievement"
        phx-target={@myself}
      >
        <div class="mt-10 space-y-8 bg-white">
          <%= if @goal.type == :binary do %>
            <.input field={f[:progress]} type="checkbox" checked={is_checked(f.data.progress)} />
          <% else %>
            <.input field={f[:progress]} type="number" min="0" />
          <% end %>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{goal: goal} = assigns, socket) do
    changeset = Tracker.change_achievement(goal.achievement)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn -> to_form(changeset) end)}
  end

  @impl true
  def handle_event("update-achievement", %{"achievement" => achievement_params}, socket) do
    goal = socket.assigns.goal

    achievement_params =
      case achievement_params do
        %{"progress" => "true"} -> %{"progress" => 1}
        %{"progress" => "false"} -> %{"progress" => 0}
        progress -> progress
      end

    case Tracker.create_or_update_achievement(goal.achievement, achievement_params) do
      {:ok, achievement} ->
        notify_parent({:saved, %{goal | achievement: achievement}})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end

    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  def is_checked(progress) do
    progress > 0
  end
end
