defmodule AdaptableCostsEvaluatorWeb.OutputView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.OutputView

  def render("index.json", %{outputs: outputs}) do
    %{data: render_many(outputs, OutputView, "output.json")}
  end

  def render("show.json", %{output: output}) do
    %{data: render_one(output, OutputView, "output.json")}
  end

  def render("output.json", %{output: output}) do
    %{
      id: output.id,
      name: output.name,
      label: output.label,
      last_value: output.last_value,
      field_schema_id: output.field_schema_id,
      formula_id: output.formula_id
    }
  end
end
