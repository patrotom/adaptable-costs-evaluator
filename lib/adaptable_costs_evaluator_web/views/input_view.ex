defmodule AdaptableCostsEvaluatorWeb.InputView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.InputView

  def render("index.json", %{inputs: inputs}) do
    %{data: render_many(inputs, InputView, "input.json")}
  end

  def render("show.json", %{input: input}) do
    %{data: render_one(input, InputView, "input.json")}
  end

  def render("input.json", %{input: input}) do
    %{
      id: input.id,
      name: input.name,
      label: input.label,
      last_value: input.last_value,
      field_schema_id: input.field_schema_id
    }
  end
end
