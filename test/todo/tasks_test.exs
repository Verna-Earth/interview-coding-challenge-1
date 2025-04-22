defmodule ToDo.TasksTest do
  use ToDo.DataCase

  alias ToDo.Tasks

  describe "tasks" do
    alias ToDo.Tasks.Task

    import ToDo.TasksFixtures

    @invalid_attrs %{name: nil, task_type: nil, frequency: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{name: "some name", task_type: "some task_type", frequency: 42}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.name == "some name"
      assert task.task_type == "some task_type"
      assert task.frequency == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{name: "some updated name", task_type: "some updated task_type", frequency: 43}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.name == "some updated name"
      assert task.task_type == "some updated task_type"
      assert task.frequency == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "records" do
    alias ToDo.Tasks.Record

    import ToDo.TasksFixtures

    @invalid_attrs %{times: nil, completed: nil}

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Tasks.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Tasks.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      valid_attrs = %{times: 42, completed: ~D[2025-04-21]}

      assert {:ok, %Record{} = record} = Tasks.create_record(valid_attrs)
      assert record.times == 42
      assert record.completed == ~D[2025-04-21]
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()
      update_attrs = %{times: 43, completed: ~D[2025-04-22]}

      assert {:ok, %Record{} = record} = Tasks.update_record(record, update_attrs)
      assert record.times == 43
      assert record.completed == ~D[2025-04-22]
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_record(record, @invalid_attrs)
      assert record == Tasks.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Tasks.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Tasks.change_record(record)
    end
  end
end
