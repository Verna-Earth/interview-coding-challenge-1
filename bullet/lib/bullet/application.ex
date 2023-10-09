defmodule Bullet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BulletWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bullet.PubSub},
      # Start Finch
      {Finch, name: Bullet.Finch},
      # datastore
      {CubDB, [data_dir: Bullet.Env.cubdb_data_dir(), name: Bullet.CubDB, auto_compact: true]},
      # Start the Endpoint (http/https)
      BulletWeb.Endpoint
      # Start a worker by calling: Bullet.Worker.start_link(arg)
      # {Bullet.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bullet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BulletWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
