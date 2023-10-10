defmodule BulletWeb.GoalLiveTest do
  use BulletWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bullet.JournalFixtures

  @create_yesno_attrs %{
    description: "new goal",
    target_unit: 1,
    goal_type: :yesno_goal
  }
  @create_numeric_attrs %{
    description: "new goal",
    target_unit: 15,
    goal_type: :numeric_goal
  }
  # @update_attrs %{
  #   id: System.unique_integer([:positive, :monotonic]),
  #   description: "new updated goal",
  #   target_unit: 50,
  #   goal_type: :numeric_goal
  # }
  @invalid_attrs %{}

  defp create_goal(_) do
    goal = goal_fixture(%{description: "Sleep for 10 hours"})
    %{goal: goal}
  end

  describe "Index" do
    setup [:create_goal]

    test "lists all goals", %{conn: conn, goal: goal} do
      {:ok, _index_live, html} = live(conn, ~p"/goals")

      assert html =~ "Today&#39;s Goals"
      assert html =~ goal.description
    end

    test "saves new yes/no goal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("a", "New Goal") |> render_click() =~
               "New Goal"

      assert_patch(index_live, ~p"/goals/new")

      assert index_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#goal-form", goal: @create_yesno_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal created successfully"
    end
  end
end
