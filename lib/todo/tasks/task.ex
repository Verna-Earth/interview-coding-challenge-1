defmodule ToDo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :task_type, Ecto.Enum, values: [:bool, :times]
    field :frequency, :integer

    belongs_to :user, ToDo.Accounts.User
    has_many :task_records, ToDo.Tasks.Record

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :task_type, :frequency, :user_id])
    |> validate_required([:name, :task_type, :frequency, :user_id])
    |> assoc_constraint(:user)
    |> validate_length(:name, min: 1)
    |> validate_length(:name, max: 100)
    |> validate_number(:frequency, greater_than: 0)
  end
end
