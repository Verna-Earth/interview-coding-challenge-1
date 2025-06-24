# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :daily_goals_tracker,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :daily_goals_tracker, DailyGoalsTrackerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DailyGoalsTrackerWeb.ErrorHTML, json: DailyGoalsTrackerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: DailyGoalsTracker.PubSub,
  live_view: [signing_salt: "hbR2dhkw"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  daily_goals_tracker: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  daily_goals_tracker: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
