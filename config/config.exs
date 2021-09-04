# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :adaptable_costs_evaluator,
  ecto_repos: [AdaptableCostsEvaluator.Repo]

# Configures the endpoint
config :adaptable_costs_evaluator, AdaptableCostsEvaluatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6S8t8+0bRbgle3xJDOvL2ZRQbXDYP18srFJeQJHq4z3D2mCAxS650ri7YpWUAa+L",
  render_errors: [view: AdaptableCostsEvaluatorWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AdaptableCostsEvaluator.PubSub,
  live_view: [signing_salt: "4rHMT12z"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
