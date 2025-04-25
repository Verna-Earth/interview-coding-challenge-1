defmodule ToDoWeb.TaskLiveTest do
  use ToDoWeb.ConnCase

  import Phoenix.LiveViewTest
  import ToDo.AccountsFixtures
  import ToDo.TasksFixtures

  @create_attrs %{name: "New task", task_type: "times", frequency: 1}
  @update_attrs %{name: "Edited task", task_type: "bool", frequency: 1}
  @invalid_attrs %{}

  @session Plug.Session.init(
             store: :cookie,
             key: "_app",
             encryption_salt: "yadayada",
             signing_salt: "yadayada"
           )

  describe "Index" do
    setup do
      user = user_fixture()
      task = task_fixture(user_id: user.id)

      conn =
        build_conn(:get, "/")
        |> Plug.Session.call(@session)
        |> fetch_session()
        |> put_session(:user_id, user.id)

      %{conn: conn, user: user, task: task}
    end

    test "lists all tasks", %{conn: conn} do
      {:ok, _index_live, html} =
        live(conn, ~p"/tasks")

      assert html =~ "Your current tasks"
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("a", "New task") |> render_click() =~
               "New task"

      assert_patch(index_live, ~p"/tasks/new")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task created successfully"
    end

    @doc """
    This test is currently failing when Edit is clicked.
    """
    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live
             |> element("#tasks-#{task.id} a", "Edit")
             |> render_click() =~
               "Edit task"

      assert_patch(index_live, ~p"/tasks/#{task}/edit")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task updated successfully"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tasks-#{task.id}")
    end
  end

  describe "Show" do
    setup do
      user = user_fixture()
      task = task_fixture(user_id: user.id)

      conn =
        build_conn(:get, "/")
        |> Plug.Session.call(@session)
        |> fetch_session()
        |> put_session(:user_id, user.id)

      %{conn: conn, user: user, task: task}
    end

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = live(conn, ~p"/tasks/#{task}")

      assert html =~ "Show Task"
    end

    @doc """
    This test is currently failing when Edit is clicked.
    """
    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, ~p"/tasks/#{task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, ~p"/tasks/#{task}/show/edit")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tasks/#{task}")

      html = render(show_live)
      assert html =~ "Task updated successfully"
    end
  end
end
