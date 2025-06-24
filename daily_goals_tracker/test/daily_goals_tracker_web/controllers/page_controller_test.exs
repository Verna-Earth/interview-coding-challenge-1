defmodule DailyGoalsTrackerWeb.PageControllerTest do
  use DailyGoalsTrackerWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) =~ ~p"/achievements"
  end
end
