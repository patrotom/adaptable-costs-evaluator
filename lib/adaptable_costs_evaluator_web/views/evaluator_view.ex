defmodule AdaptableCostsEvaluatorWeb.EvaluatorView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.EvaluatorView

  def render("index.json", %{evaluators: evaluators}) do
    %{data: render_many(evaluators, EvaluatorView, "evaluator.json")}
  end

  def render("show.json", %{evaluator: evaluator}) do
    %{data: render_one(evaluator, EvaluatorView, "evaluator.json")}
  end

  def render("evaluator.json", %{evaluator: evaluator}) do
    %{
      id: evaluator.id,
      name: evaluator.name,
      description: evaluator.description,
      module: evaluator.module
    }
  end
end
