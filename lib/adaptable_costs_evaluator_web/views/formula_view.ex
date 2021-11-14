defmodule AdaptableCostsEvaluatorWeb.FormulaView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.{FormulaView, OutputView}

  def render("index.json", %{formulas: formulas}) do
    %{data: render_many(formulas, FormulaView, "formula.json")}
  end

  def render("show.json", %{formula: formula}) do
    %{data: render_one(formula, FormulaView, "formula.json")}
  end

  def render("formula.json", %{formula: formula}) do
    %{
      id: formula.id,
      name: formula.name,
      label: formula.label,
      definition: formula.definition,
      computation_id: formula.computation_id,
      evaluator_id: formula.evaluator_id
    }
  end

  def render("evaluate.json", %{outputs: outputs, result: result}) do
    %{
      data: %{
        result: result,
        affected_outputs: OutputView.render("index.json", outputs: outputs)
      }
    }
  end
end
