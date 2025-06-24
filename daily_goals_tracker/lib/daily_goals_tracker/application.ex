defmodule DailyGoalsTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias DailyGoalsTracker.Seeder

  @is_test Mix.env() == :test

  @impl true
  def start(_type, _args) do
    children = [
      DailyGoalsTrackerWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:daily_goals_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DailyGoalsTracker.PubSub},
      if(@is_test,
        do: DailyGoalsTracker.Store,
        else: {DailyGoalsTracker.Store, seed: Seeder.seed()}
      ),
      DailyGoalsTrackerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DailyGoalsTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DailyGoalsTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
