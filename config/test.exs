# Test environment configuration
use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :adaptable_costs_evaluator, AdaptableCostsEvaluator.Repo,
  username: System.get_env("PGUSER", "postgres"),
  password: System.get_env("PGPASSWORD", "postgres"),
  database:
    "#{System.get_env("PGDATABASE_TEST", "adaptable_costs_evaluator_test")}#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("PGHOST", "localhost"),
  port: System.get_env("PGPORT", "5432"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :adaptable_costs_evaluator, AdaptableCostsEvaluatorWeb.Endpoint,
  http: [port: System.get_env("TEST_APP_PORT", "4002")],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
