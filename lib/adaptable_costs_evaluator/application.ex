defmodule AdaptableCostsEvaluator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AdaptableCostsEvaluator.Repo,
      # Start the Telemetry supervisor
      AdaptableCostsEvaluatorWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AdaptableCostsEvaluator.PubSub},
      # Start the Endpoint (http/https)
      AdaptableCostsEvaluatorWeb.Endpoint
      # Start a worker by calling: AdaptableCostsEvaluator.Worker.start_link(arg)
      # {AdaptableCostsEvaluator.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AdaptableCostsEvaluator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AdaptableCostsEvaluatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
