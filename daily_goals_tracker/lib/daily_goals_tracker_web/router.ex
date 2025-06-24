defmodule DailyGoalsTrackerWeb.Router do
  use DailyGoalsTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DailyGoalsTrackerWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" => "default-src 'self'; style-src 'self' 'unsafe-inline'"
    }
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DailyGoalsTrackerWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/achievements", AchievementLive.Index, :show
    live "/achievements/:day", AchievementLive.Index, :show

    live "/goals", GoalLive.Index, :index
    live "/goals/new", GoalLive.Index, :new
    live "/goals/:id/edit", GoalLive.Index, :edit
  end
end
