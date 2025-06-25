defmodule DailyGoalsTrackerWeb.PageController do
  use DailyGoalsTrackerWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/achievements")
  end
end
