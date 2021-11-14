# Production environment configuration
use Mix.Config

# Environment variables
app_host = System.get_env("APP_HOST") || raise "APP_HOST is missing"
app_port = System.get_env("APP_PORT") || raise "APP_PORT is missing"
key_file = System.get_env("KEY_FILE") || raise "KEY_FILE is missing"
cert_file = System.get_env("CERT_FILE") || raise "CERT_FILE is missing"
guardian_issuer = System.get_env("GUARDIAN_ISSUER") || raise "GUARDIAN_ISSUER is missing"
guardian_secret_key =
  System.get_env("GUARDIAN_SECRET_KEY") || raise "GUARDIAN_SECRET_KEY is missing"
secret_key_base = System.get_env("SECRET_KEY_BASE") || raise "SECRET_KEY_BASE is missing"
database_url = System.get_env("DATABASE_URL") || raise "DATABASE_URL is missing"
pool_size = String.to_integer(System.get_env("POOL_SIZE", "10"))

# Configure the endpoint
config :adaptable_costs_evaluator, AdaptableCostsEvaluatorWeb.Endpoint,
  url: [host: app_host, port: app_port],
  https: [
    port: app_port,
    cipher_suite: :strong,
    keyfile: key_file,
    certfile: cert_file,
    transport_options: [socket_opts: [:inet6]]
  ],
  force_ssl: [hsts: true],
  secret_key_base: secret_key_base,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Configure database
config :adaptable_costs_evaluator, AdaptableCostsEvaluator.Repo,
  ssl: true,
  url: database_url,
  pool_size: pool_size

# Configure Guardian
config :adaptable_costs_evaluator, AdaptableCostsEvaluator.Guardian,
  issuer: guardian_issuer,
  secret_key: guardian_secret_key

# Do not print debug messages in production
config :logger, level: :info
