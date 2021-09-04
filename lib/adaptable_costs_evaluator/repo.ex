defmodule AdaptableCostsEvaluator.Repo do
  use Ecto.Repo,
    otp_app: :adaptable_costs_evaluator,
    adapter: Ecto.Adapters.Postgres
end
