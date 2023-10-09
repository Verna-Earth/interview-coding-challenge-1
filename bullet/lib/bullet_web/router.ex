defmodule BulletWeb.Router do
  use BulletWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BulletWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BulletWeb do
    pipe_through :browser

    live_session :default do
      live "/goals", GoalLive.Index, :index
      live "/goals/new", GoalLive.Index, :new
      # live "/goals/:id", GoalLive.Show, :show
      # live "/goals/:id/edit", GoalLive.Index, :edit

      live "/records", GoalRecordLive.Index, :index
      live "/records/:goal_id/today", GoalRecordLive.Index, :today
      live "/records/:goal_id/past", GoalRecordLive.Index, :past

      live "/reporting", ReportingLive.Index, :index
    end

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BulletWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bullet, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BulletWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
