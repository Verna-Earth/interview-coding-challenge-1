defmodule ToDo.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ToDo.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        frequency: 42,
        name: "some name",
        task_type: :times
      })
      |> ToDo.Tasks.create_task()

    task
  end

  @doc """
  Generate a record.
  """
  def record_fixture(attrs \\ %{}) do
    {:ok, record} =
      attrs
      |> Enum.into(%{
        completed: ~D[2025-04-21],
        times: 42
      })
      |> ToDo.Tasks.create_record()

    record
  end
end
