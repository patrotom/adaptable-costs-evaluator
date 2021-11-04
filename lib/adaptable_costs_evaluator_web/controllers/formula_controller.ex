defmodule AdaptableCostsEvaluatorWeb.FormulaController do
  use AdaptableCostsEvaluatorWeb, :controller

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.{Formulas, Computations}
  alias AdaptableCostsEvaluator.Formulas.Formula

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, %{"computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Formula, :list, current_user(conn), computation) do
      formulas = Formulas.list_formulas(computation)
      render(conn, "index.json", formulas: formulas)
    end
  end

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

  def show(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Formula, :read, current_user(conn), computation) do
      formula = Formulas.get_formula!(id, computation)
      render(conn, "show.json", formula: formula)
    end
  end

  def update(conn, %{"id" => id, "formula" => formula_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    formula = Formulas.get_formula!(id, computation)

    with :ok <- Bodyguard.permit(Formula, :update, current_user(conn), computation),
         {:ok, %Formula{} = formula} <- Formulas.update_formula(formula, formula_params) do
      render(conn, "show.json", formula: formula)
    end
  end

  def delete(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    formula = Formulas.get_formula!(id, computation)

    with :ok <- Bodyguard.permit(Formula, :delete, current_user(conn), computation),
         {:ok, %Formula{}} <- Formulas.delete_formula(formula) do
      send_resp(conn, :no_content, "")
    end
  end

  defp get_computation!(id), do: Computations.get_computation!(id)
end
