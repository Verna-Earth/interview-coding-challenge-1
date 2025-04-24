defmodule ToDo.Tasks.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :times, :integer
    field :completed, :date

    belongs_to :task, ToDo.Tasks.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:completed, :times, :task_id])
    |> validate_required([:completed, :times, :task_id])
    |> assoc_constraint(:task)
    |> validate_number(:times, greater_than: 0)
    |> validate_not_in_future(:completed)
  end

  defp validate_not_in_future(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      if value > Date.utc_today() do
        changeset
        |> add_error(field, "cannot be in the future.")
      else
        changeset
      end
    end)
  end
end
