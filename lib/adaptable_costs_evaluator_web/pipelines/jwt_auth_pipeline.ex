defmodule AdaptableCostsEvaluatorWeb.Pipelines.JWTAuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :adaptable_costs_evaluator,
                              module: AdaptableCostsEvaluator.Guardian,
                              error_handler: AdaptableCostsEvaluatorWeb.Handlers.JWTAuthHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
