# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :swift_bet,
  ecto_repos: [SwiftBet.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :swift_bet, SwiftBetWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: SwiftBetWeb.ErrorHTML, json: SwiftBetWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SwiftBet.PubSub,
  live_view: [signing_salt: "HGWp4z9A"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :swift_bet, SwiftBet.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]




# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :games, Oban,
  repo: Swift.Repo,
  queues: [
    
    events: [limit: 1000],
    plugins: [
      {Oban.Plugins.Cron,
       crontab: [
         {"* * * * *", SwiftBet.Worker},
        #  {"0 * * * *", MyApp.HourlyWorker, args: %{custom: "arg"}},
        #  {"0 0 * * *", MyApp.DailyWorker, max_attempts: 1},
        #  {"0 12 * * MON", MyApp.MondayWorker, queue: :scheduled, tags: ["mondays"]},
        #  {"@daily", MyApp.AnotherDailyWorker}
       ]}],


    default: 5
  ]


  config :swift_bet, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 10],
  repo: SwiftBet.Repo

  
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
