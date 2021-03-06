defmodule AdaptableCostsEvaluator.MixProject do
  use Mix.Project

  def project do
    [
      app: :adaptable_costs_evaluator,
      version: version(),
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [
        ignore_modules: [
          ~r/^(AdaptableCostsEvaluatorWeb\.ApiSpec).*$/,
          AdaptableCostsEvaluatorWeb,
          AdaptableCostsEvaluatorWeb.ChannelCase,
          AdaptableCostsEvaluatorWeb.UserSocket,
          AdaptableCostsEvaluator.Guardian.Plug,
          AdaptableCostsEvaluator.Repo,
          AdaptableCostsEvaluator.DataCase,
          AdaptableCostsEvaluator.Application
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AdaptableCostsEvaluator.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp version do
    case File.read("VERSION") do
      {:error, _} -> raise "VERSION file is missing or corrupted!"
      {:ok, version} -> version
    end
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.12"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:comeonin, "~> 5.3"},
      {:bcrypt_elixir, "~> 2.3"},
      {:guardian, "~> 2.2"},
      {:bodyguard, "~> 2.4"},
      {:abacus, "~> 2.0"},
      {:ex_json_schema, "~> 0.9.1"},
      {:open_api_spex, "~> 3.11"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
