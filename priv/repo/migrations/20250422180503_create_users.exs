defmodule ToDo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, size: 50, null: false
      add :email, :string, size: 50, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
