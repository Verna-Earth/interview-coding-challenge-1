defmodule BulletWeb.GoalRecordLiveTest do
  use BulletWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bullet.JournalFixtures

  @invalid_attrs %{}

  defp create_goal_record(_) do
    goal_record = goal_record_fixture()
    %{goal_record: goal_record}
  end

  describe "Index" do
    setup [:create_goal_record]

    test "lists all goals", %{conn: conn, goal_record: goal_record} do
      {:ok, _index_live, html} = live(conn, ~p"/records")

      assert html =~ "Past Records"
      assert html =~ goal_record.goal.description
      assert html =~ goal_record.record_date |> Date.to_string()
    end
  end


end
