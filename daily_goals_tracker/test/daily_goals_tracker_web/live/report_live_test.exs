defmodule DailyGoalsTrackerWeb.ReportLiveTest do
  use DailyGoalsTrackerWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  alias DailyGoalsTracker.Tracker

  alias DailyGoalsTracker.TrackerFactory, as: TF

  describe "Show" do
    test "when no goals", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/reports")
      assert html =~ "Achievement Reports"
    end

    test "selected goal report", %{conn: conn} do
      today = Date.utc_today()

      {:ok, index_live, _html} = live(conn, ~p"/reports")

      assert {:ok, goal} =
               TF.params_for(:goal, name: "Goal one", type: :numeric, target: 100)
               |> Tracker.create_goal()

      for day_offset <- -0..-14//-1 do
        assert {:ok, _achievement} =
                 TF.params_for(:achievement,
                   goal_id: goal.id,
                   progress: 50,
                   day: Date.add(today, day_offset)
                 )
                 |> Tracker.create_achievement()
      end

      assert index_live
             |> element("#goal-selector_goal")
             |> render_change(%{"goal" => goal.id})

      html = render(index_live)
      assert html =~ "Achievement Reports"
      assert html =~ "Target: 100"
      assert html =~ "50%"
    end
  end
end
