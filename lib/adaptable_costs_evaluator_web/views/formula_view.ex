defmodule AdaptableCostsEvaluatorWeb.FormulaView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.FormulaView

  def render("index.json", %{formulas: formulas}) do
    %{data: render_many(formulas, FormulaView, "formula.json")}
  end

  def render("show.json", %{formula: formula}) do
    %{data: render_one(formula, FormulaView, "formula.json")}
  end

  def render("formula.json", %{formula: formula}) do
    %{id: formula.id,
      name: formula.name,
      label: formula.label,
      definition: formula.definition,
      computation_id: formula.computation_id}
  end
end
