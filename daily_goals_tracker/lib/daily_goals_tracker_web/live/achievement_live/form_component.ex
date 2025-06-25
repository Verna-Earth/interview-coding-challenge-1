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
        <.binary_checkbox
          :if={@goal.type == :binary}
          field={f[:progress]}
          checked={is_checked(f.data.progress)}
        />
        <.numeric_input :if={@goal.type == :numeric} field={f[:progress]} />
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

  defp is_checked(progress), do: progress > 0

  defp binary_checkbox(assigns) do
    ~H"""
    <div class="inline-flex items-center">
      <label class="flex items-center cursor-pointer relative">
        <input type="hidden" name={@field.name} value="0" />
        <input
          type="checkbox"
          checked={@checked}
          name={@field.name}
          class="peer h-6 w-6 cursor-pointer transition-all appearance-none rounded shadow hover:shadow-md border border-slate-300 checked:bg-blue-600 checked:border-blue-600 focus:ring-0"
          value="1"
        />
        <span class="absolute text-white opacity-0 peer-checked:opacity-100 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            viewBox="0 0 20 20"
            fill="currentColor"
            stroke="currentColor"
            stroke-width="1"
          >
            <path
              fill-rule="evenodd"
              d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
              clip-rule="evenodd"
            >
            </path>
          </svg>
        </span>
      </label>
    </div>
    """
  end

  defp numeric_input(assigns) do
    ~H"""
    <input
      type="number"
      name={@field.name}
      value={Phoenix.HTML.Form.normalize_value("number", @field.value)}
      min="0"
      class="focus:ring-0 p-2 border-0 rounded-lg hover:border-1"
    />
    """
  end
end
