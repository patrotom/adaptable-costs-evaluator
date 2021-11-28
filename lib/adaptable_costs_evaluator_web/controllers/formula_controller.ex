defmodule AdaptableCostsEvaluatorWeb.FormulaController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.{Formulas, Computations}
  alias AdaptableCostsEvaluator.Formulas.Formula

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["Formulas"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all Formulas in the Computation",
    parameters: [Parameters.computation_id()],
    responses:
      [
        ok: {"Formulas list response", "application/json", Schemas.FormulasResponse}
      ] ++ Errors.internal_errors()

  def index(conn, %{"computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Formula, :list, current_user(conn), computation) do
      formulas = Formulas.list_formulas(computation)
      render(conn, "index.json", formulas: formulas)
    end
  end

  operation :create,
    summary: "Create a new Formula in the Computation",
    parameters: [Parameters.computation_id()],
    request_body:
      {"Formula attributes", "application/json", Schemas.FormulaRequest, required: true},
    responses:
      [
        created: {"Formula response", "application/json", Schemas.FormulaResponse}
      ] ++ Errors.all_errors()

  def create(conn, %{"formula" => formula_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    formula_params = Map.put(formula_params, "computation_id", computation_id)

    with :ok <- Bodyguard.permit(Formula, :create, current_user(conn), computation),
         {:ok, %Formula{} = formula} <- Formulas.create_formula(formula_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.computation_formula_path(conn, :show, computation_id, formula)
      )
      |> render("show.json", formula: formula)
    end
  end

  operation :show,
    summary: "Retrieve the Formula from the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    responses:
      [
        ok: {"Formula response", "application/json", Schemas.FormulaResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Formula, :read, current_user(conn), computation) do
      formula = Formulas.get_formula!(id, computation)
      render(conn, "show.json", formula: formula)
    end
  end

  operation :update,
    summary: "Update the Formula in the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    request_body:
      {"Formula attributes", "application/json", Schemas.FormulaRequest, required: true},
    responses:
      [
        ok: {"Formula response", "application/json", Schemas.FormulaResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "formula" => formula_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    formula = Formulas.get_formula!(id, computation)

    with :ok <- Bodyguard.permit(Formula, :update, current_user(conn), computation),
         {:ok, %Formula{} = formula} <- Formulas.update_formula(formula, formula_params) do
      render(conn, "show.json", formula: formula)
    end
  end

  operation :delete,
    summary: "Delete the Formula in the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    responses:
      [
        no_content: {"Formula was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    formula = Formulas.get_formula!(id, computation)

    with :ok <- Bodyguard.permit(Formula, :delete, current_user(conn), computation),
         {:ok, %Formula{}} <- Formulas.delete_formula(formula) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :evaluate,
    summary: "Run the evaluation of the Formula",
    description: """
    Runs the evaluation of the Formula and returns the result of the evaluation.
    It also returns the list of affected Outputs. An affected Output is an
    Output where the evaluation wrote the result to the `last_value` attribute.

    If the given Output was not affected (even though the `formula_id` is set),
    it means that the validation of the result value against the linked FieldSchema
    failed.
    """,
    parameters: [Parameters.computation_id()],
    responses:
      [
        ok: {"Formula evaluation response", "application/json", Schemas.FormulaEvaluationResponse}
      ] ++ Errors.internal_errors()

  def evaluate(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    formula = Formulas.get_formula!(id, computation)

    with :ok <- Bodyguard.permit(Formula, :evaluate, current_user(conn), computation),
         {:ok, %{outputs: outputs, result: result}} <- Formulas.evaluate_formula(formula) do
      render(conn, "evaluate.json", outputs: outputs, result: result)
    end
  end

  defp get_computation!(id), do: Computations.get_computation!(id)
end
