defmodule DailyGoalsTrackerWeb.AchievementLiveTest do
  use DailyGoalsTrackerWeb.ConnCase, async: false
  import DailyGoalsTrackerWeb.AchievementLive.Index, only: [fmt_date: 1]
  import Phoenix.LiveViewTest

  alias DailyGoalsTracker.Tracker
  alias DailyGoalsTracker.Tracker.Achievement

  alias DailyGoalsTracker.TrackerFactory, as: TF

  describe "Index" do
    test "redirect to today's achievements", %{conn: conn} do
      today = Date.utc_today() |> Date.to_iso8601()

      assert {:error, {:live_redirect, %{to: to}}} = result = live(conn, ~p"/achievements")
      assert to == "/achievements/#{today}"

      {:ok, _view, html} = follow_redirect(result, conn)

      assert html =~ "Today&#39;s - Achievements"
    end

    test "lists today's achievements", %{conn: conn} do
      today = Date.utc_today() |> Date.to_iso8601()

      assert {:ok, goal} = TF.params_for(:goal, target: 1) |> Tracker.create_goal()

      {:ok, _index_live, html} = live(conn, ~p"/achievements/#{today}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
    end

    test "lists yesterday's achievements", %{conn: conn} do
      today = Date.utc_today() |> Date.add(-1) |> Date.to_iso8601()

      assert {:ok, goal} = TF.params_for(:goal, target: 1) |> Tracker.create_goal()

      {:ok, _index_live, html} = live(conn, ~p"/achievements/#{today}")

      assert html =~ "Yesterday&#39;s - Achievements"
      assert html =~ goal.name
    end

    test "lists uncompleted binary goal", %{conn: conn} do
      today = Date.utc_today() |> Date.to_iso8601()

      assert {:ok, goal} = TF.params_for(:goal, target: 1, type: :binary) |> Tracker.create_goal()

      {:ok, index_live, html} = live(conn, ~p"/achievements/#{today}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
      assert html =~ "0%"

      assert has_element?(
               index_live,
               ~s{#goal-#{goal.id}-achievement-form_progress[type="checkbox"]}
             )
    end

    test "lists uncompleted numeric goal", %{conn: conn} do
      today = Date.utc_today() |> Date.to_iso8601()

      assert {:ok, goal} =
               TF.params_for(:goal, target: 10, type: :numeric) |> Tracker.create_goal()

      {:ok, index_live, html} = live(conn, ~p"/achievements/#{today}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
      assert html =~ "0%"

      assert has_element?(
               index_live,
               ~s{#goal-#{goal.id}-achievement-form_progress[type="number"][value="0"]}
             )
    end

    test "lists completed binary goal", %{conn: conn} do
      today = Date.utc_today() |> Date.to_iso8601()

      assert {:ok, goal} = TF.params_for(:goal, target: 1, type: :binary) |> Tracker.create_goal()

      assert {:ok, _achievement} =
               TF.params_for(:achievement, goal_id: goal.id, progress: 1)
               |> Tracker.create_achievement()

      {:ok, index_live, html} = live(conn, ~p"/achievements/#{today}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
      assert html =~ "100%"

      assert has_element?(
               index_live,
               ~s{#goal-#{goal.id}-achievement-form_progress[type="checkbox"][checked]}
             )
    end

    test "lists completed numeric goal", %{conn: conn} do
      today = Date.utc_today() |> Date.to_iso8601()

      assert {:ok, goal} =
               TF.params_for(:goal, target: 10, type: :numeric) |> Tracker.create_goal()

      assert {:ok, _achievement} =
               TF.params_for(:achievement, goal_id: goal.id, progress: 10)
               |> Tracker.create_achievement()

      {:ok, index_live, html} = live(conn, ~p"/achievements/#{today}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
      assert html =~ "100%"

      assert has_element?(
               index_live,
               ~s{#goal-#{goal.id}-achievement-form_progress[type="number"][value="10"]}
             )
    end

    test "complete a binary goal", %{conn: conn} do
      today = Date.utc_today()

      assert {:ok, goal} = TF.params_for(:goal, target: 1, type: :binary) |> Tracker.create_goal()
      %{id: goal_id} = goal

      {:ok, index_live, html} = live(conn, ~p"/achievements/#{Date.to_iso8601(today)}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
      assert html =~ "0%"

      assert index_live
             |> form("#goal-#{goal.id}-achievement-form",
               achievement: %{progress: "true"}
             )
             |> render_change()

      html = render(index_live)
      assert html =~ "100%"

      assert [%Achievement{goal_id: ^goal_id, day: ^today, progress: 1}] =
               Tracker.get_goal_achievements(goal)
    end

    test "complete a numeric goal", %{conn: conn} do
      today = Date.utc_today()

      assert {:ok, goal} =
               TF.params_for(:goal, target: 4, type: :numeric) |> Tracker.create_goal()

      %{id: goal_id} = goal

      {:ok, index_live, html} = live(conn, ~p"/achievements/#{Date.to_iso8601(today)}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
      assert html =~ "0%"

      assert index_live
             |> form("#goal-#{goal.id}-achievement-form",
               achievement: %{progress: 2}
             )
             |> render_change()

      html = render(index_live)
      assert html =~ "50%"

      assert [%Achievement{goal_id: ^goal_id, day: ^today, progress: 2}] =
               Tracker.get_goal_achievements(goal)

      assert index_live
             |> form("#goal-#{goal.id}-achievement-form",
               achievement: %{progress: 4}
             )
             |> render_change()

      html = render(index_live)
      assert html =~ "100%"

      assert [%Achievement{goal_id: ^goal_id, day: ^today, progress: 4}] =
               Tracker.get_goal_achievements(goal)

      assert index_live
             |> form("#goal-#{goal.id}-achievement-form",
               achievement: %{progress: 6}
             )
             |> render_change()

      html = render(index_live)
      assert html =~ "150%"

      assert [%Achievement{goal_id: ^goal_id, day: ^today, progress: 6}] =
               Tracker.get_goal_achievements(goal)
    end

    test "select previous day", %{conn: conn} do
      today = Date.utc_today()
      yesterday = Date.add(today, -1)

      assert {:ok, goal} =
               TF.params_for(:goal, target: 4, type: :numeric) |> Tracker.create_goal()

      assert {:ok, _achievement} =
               TF.params_for(:achievement, goal_id: goal.id, progress: 2, day: today)
               |> Tracker.create_achievement()

      assert {:ok, _achievement} =
               TF.params_for(:achievement, goal_id: goal.id, progress: 3, day: yesterday)
               |> Tracker.create_achievement()

      {:ok, index_live, html} = live(conn, ~p"/achievements/#{Date.to_iso8601(today)}")

      assert html =~ "Today&#39;s - Achievements"
      assert html =~ goal.name
      assert html =~ "50%"

      assert index_live
             |> element(~s{a[href="/achievements/#{Date.to_iso8601(yesterday)}"]})
             |> render_click()

      html = render(index_live)
      assert html =~ "Yesterday&#39;s - Achievements"
      assert html =~ "75%"
    end
  end

  test "select next day", %{conn: conn} do
    today = Date.utc_today()
    yesterday = Date.utc_today() |> Date.add(-1)
    two_days_ago = Date.utc_today() |> Date.add(-2)

    assert {:ok, goal} =
             TF.params_for(:goal, target: 4, type: :numeric) |> Tracker.create_goal()

    assert {:ok, _achievement} =
             TF.params_for(:achievement, goal_id: goal.id, progress: 2, day: yesterday)
             |> Tracker.create_achievement()

    assert {:ok, _achievement} =
             TF.params_for(:achievement, goal_id: goal.id, progress: 3, day: two_days_ago)
             |> Tracker.create_achievement()

    {:ok, index_live, html} = live(conn, ~p"/achievements/#{Date.to_iso8601(two_days_ago)}")

    assert html =~ "#{fmt_date(two_days_ago)} - Achievements"
    assert html =~ goal.name
    assert html =~ "75%"

    assert index_live
           |> element(~s{a[href="/achievements/#{Date.to_iso8601(yesterday)}"]})
           |> render_click()

    html = render(index_live)
    assert html =~ "Yesterday&#39;s - Achievements"
    assert html =~ "50%"

    assert index_live
           |> element(~s{a[href="/achievements/#{Date.to_iso8601(today)}"]})
           |> render_click()

    html = render(index_live)
    assert html =~ "Today&#39;s - Achievements"
    assert html =~ "0%"
  end
end
