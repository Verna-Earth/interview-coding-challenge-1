defmodule DailyGoalsTrackerWeb.GoalLiveTest do
  use DailyGoalsTrackerWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias DailyGoalsTracker.Tracker
  alias DailyGoalsTracker.Tracker.Goal

  alias DailyGoalsTracker.TrackerFactory, as: TF

  @invalid_attrs %{name: nil, target: nil, type: nil}

  describe "Index" do
    setup [:create_goal]

    test "lists all goals", %{conn: conn, goal: goal} do
      {:ok, _index_live, html} = live(conn, ~p"/goals")
      assert html =~ "My Goals"
      assert html =~ goal.name
    end

    test "shows erros on saves when date invalid", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("a", "New Goal") |> render_click() =~
               "New Goal"

      assert_patch(index_live, ~p"/goals/new")

      assert index_live
             |> form("#goal-form", goal: %{name: nil, type: nil})
             |> render_change() =~ "can&#39;t be blank"
    end

    test "saves new binary goal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("a", "New Goal") |> render_click() =~
               "New Goal"

      assert_patch(index_live, ~p"/goals/new")

      assert index_live
             |> form("#goal-form", goal: %{name: "Goal name 1", type: :binary})
             |> render_submit()

      assert_patch(index_live, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal created successfully"
      assert html =~ "Goal name 1"
      assert html =~ "Yes/No"
    end

    test "saves new numerical goal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("a", "New Goal") |> render_click() =~
               "New Goal"

      assert_patch(index_live, ~p"/goals/new")

      assert index_live
             |> element("#goal_type")
             |> render_change(%{"goal" => %{"type" => "numeric"}}) =~ "Target"

      assert index_live
             |> form("#goal-form", goal: %{name: "Goal name 1", type: "numeric", target: 100})
             |> render_submit()

      assert_patch(index_live, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal created successfully"
      assert html =~ "Goal name 1"
      assert html =~ "Numerical"
    end

    test "updates goal in listing from binary to numeric", %{conn: conn, goal: goal} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Edit") |> render_click() =~
               "Edit Goal"

      assert_patch(index_live, ~p"/goals/#{goal}/edit")

      assert index_live
             |> element("#goal_type")
             |> render_change(%{"goal" => %{"type" => "numeric"}}) =~ "Target"

      assert index_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#goal-form",
               goal: %{name: "Goal name 1 updated", target: 999, type: :numeric}
             )
             |> render_submit()

      assert_patch(index_live, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "Goal name 1 updated"
      assert html =~ "Numerical"
    end

    test "updates goal in listing from numeric to binary", %{conn: conn} do
      {:ok, %Goal{} = goal} =
        TF.params_for(:goal, name: "Goal name 2", type: :numeric, target: 100)
        |> Tracker.create_goal()

      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Edit") |> render_click() =~
               "Edit Goal"

      assert_patch(index_live, ~p"/goals/#{goal}/edit")

      assert index_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#goal-form",
               goal: %{name: "Goal name 2 updated", target: 1, type: :binary}
             )
             |> render_submit()

      assert_patch(index_live, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "Goal name 2 updated"
      assert html =~ "Yes/No"
    end

    test "deletes goal in listing", %{conn: conn, goal: goal} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#goals-#{goal.id}")
    end
  end

  defp create_goal(_) do
    {:ok, %Goal{} = goal} =
      TF.params_for(:goal, type: :binary, target: 1) |> Tracker.create_goal()

    %{goal: goal}
  end
end
