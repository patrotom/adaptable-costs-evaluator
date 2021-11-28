defmodule AdaptableCostsEvaluatorWeb.EvaluatorController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Evaluators
  alias AdaptableCostsEvaluator.Evaluators.Evaluator

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["Evaluators"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all Evaluators",
    responses:
      [
        ok: {"Evaluators list response", "application/json", Schemas.EvaluatorsResponse}
      ] ++ Errors.internal_errors()

  def index(conn, _params) do
    with :ok <- Bodyguard.permit(Evaluator, :list, current_user(conn), nil) do
      evaluators = Evaluators.list_evaluators()
      render(conn, "index.json", evaluators: evaluators)
    end
  end

  operation :create,
    summary: "Create a new Evaluator",
    request_body:
      {"Evaluator attributes", "application/json", Schemas.EvaluatorRequest, required: true},
    responses:
      [
        created: {"Evaluator response", "application/json", Schemas.EvaluatorResponse}
      ] ++ Errors.all_errors()

  def create(conn, %{"evaluator" => evaluator_params}) do
    with :ok <- Bodyguard.permit(Evaluator, :create, current_user(conn), nil),
         {:ok, %Evaluator{} = evaluator} <- Evaluators.create_evaluator(evaluator_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.evaluator_path(conn, :show, evaluator))
      |> render("show.json", evaluator: evaluator)
    end
  end

  operation :show,
    summary: "Retrieve the Evaluator",
    parameters: [Parameters.id()],
    responses:
      [
        ok: {"Evaluator response", "application/json", Schemas.EvaluatorResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(Evaluator, :read, current_user(conn), nil) do
      evaluator = Evaluators.get_evaluator!(id)
      render(conn, "show.json", evaluator: evaluator)
    end
  end

  operation :update,
    summary: "Update the Evaluator",
    parameters: [Parameters.id()],
    request_body:
      {"Evaluator attributes", "application/json", Schemas.EvaluatorRequest, required: true},
    responses:
      [
        ok: {"Evaluator response", "application/json", Schemas.EvaluatorResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "evaluator" => evaluator_params}) do
    evaluator = Evaluators.get_evaluator!(id)

    with :ok <- Bodyguard.permit(Evaluator, :update, current_user(conn), nil),
         {:ok, %Evaluator{} = evaluator} <-
           Evaluators.update_evaluator(evaluator, evaluator_params) do
      render(conn, "show.json", evaluator: evaluator)
    end
  end

  operation :delete,
    summary: "Delete the Evaluator",
    parameters: [Parameters.id()],
    responses:
      [
        no_content: {"Evaluator was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{"id" => id}) do
    evaluator = Evaluators.get_evaluator!(id)

    with :ok <- Bodyguard.permit(Evaluator, :delete, current_user(conn), nil),
         {:ok, %Evaluator{}} <- Evaluators.delete_evaluator(evaluator) do
      send_resp(conn, :no_content, "")
    end
  end
end
