# General application configuration
use Mix.Config

# Environment variables
app_host = System.get_env("APP_HOST", "localhost")
guardian_issuer = System.get_env("GUARDIAN_ISSUER", "Adaptable Costs Evaluator")
secret_key_base =
  System.get_env(
    "SECRET_KEY_BASE",
    "6S8t8+0bRbgle3xJDOvL2ZRQbXDYP18srFJeQJHq4z3D2mCAxS650ri7YpWUAa+L"
  )
guardian_secret_key =
  System.get_env(
    "GUARDIAN_SECRET_KEY",
    "EvlG5TLClHAO42bTKoeAKVE4H7A8TRCmKMuEQMmaNKg78/4z2ECEN5V5+4zVus+K"
  )
lv_signing_salt = System.get_env("LV_SIGNING_SALT", "Frd8eAcsHvOMrRbk")

# Configure Ecto
config :adaptable_costs_evaluator,
  ecto_repos: [AdaptableCostsEvaluator.Repo]

# Configure the endpoint
config :adaptable_costs_evaluator, AdaptableCostsEvaluatorWeb.Endpoint,
  url: [host: app_host],
  secret_key_base: secret_key_base,
  render_errors: [view: AdaptableCostsEvaluatorWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AdaptableCostsEvaluator.PubSub,
  live_view: [signing_salt: lv_signing_salt]

# Configure Guardian
config :adaptable_costs_evaluator, AdaptableCostsEvaluator.Guardian,
  issuer: guardian_issuer,
  secret_key: guardian_secret_key

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure Bodyguard
config :bodyguard,
  default_error: :forbidden

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
