defmodule ToDo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string

    has_many :tasks, ToDo.Tasks.Task
    has_many :task_records, through: [:tasks, :records]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 1)
    |> validate_length(:name, max: 50)
    |> validate_length(:email, min: 3)
    |> validate_length(:email, max: 50)
    |> validate_format(:email, ~r/@/)
  end
end
