# Development environment configuration
use Mix.Config

# Configure your database
config :adaptable_costs_evaluator, AdaptableCostsEvaluator.Repo,
  username: System.get_env("PGUSER", "postgres"),
  password: System.get_env("PGPASSWORD", "postgres"),
  database: System.get_env("PGDATABASE_DEV", "adaptable_costs_evaluator_dev"),
  hostname: System.get_env("PGHOST", "localhost"),
  port: System.get_env("PGPORT", "5432"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :adaptable_costs_evaluator, AdaptableCostsEvaluatorWeb.Endpoint,
  http: [port: System.get_env("APP_PORT", "4000")],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
