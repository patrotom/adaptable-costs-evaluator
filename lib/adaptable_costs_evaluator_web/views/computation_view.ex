defmodule AdaptableCostsEvaluatorWeb.ComputationView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.ComputationView

  def render("index.json", %{computations: computations}) do
    %{data: render_many(computations, ComputationView, "computation.json")}
  end

  def render("show.json", %{computation: computation}) do
    %{data: render_one(computation, ComputationView, "computation.json")}
  end

  def render("computation.json", %{computation: computation}) do
    %{
      id: computation.id,
      name: computation.name,
      creator_id: computation.creator_id,
      organization_id: computation.organization_id
    }
  end
end
