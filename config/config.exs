# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :color_picker,
  ecto_repos: [ColorPicker.Repo]

# Configures the endpoint
config :color_picker, ColorPickerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/oi3GsCcbfLuwQWJKLEs1x7uX1QDDY7DpySfuHmtMd+0N+7H20t+UQP2a1tbPdMf",
  render_errors: [view: ColorPickerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ColorPicker.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Slime configuration
config :phoenix, :template_engines,
    slim: PhoenixSlime.Engine,
    slime: PhoenixSlime.Engine,
    slimleex: PhoenixSlime.LiveViewEngine # If you want to use LiveView

# Configures Hound integration tests
config :hound, driver: "selenium"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
