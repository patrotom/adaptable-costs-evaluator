defmodule AdaptableCostsEvaluatorWeb.FieldSchemaView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.FieldSchemaView

  def render("index.json", %{field_schemas: field_schemas}) do
    %{data: render_many(field_schemas, FieldSchemaView, "field_schema.json")}
  end

  def render("show.json", %{field_schema: field_schema}) do
    %{data: render_one(field_schema, FieldSchemaView, "field_schema.json")}
  end

  def render("field_schema.json", %{field_schema: field_schema}) do
    %{id: field_schema.id,
      name: field_schema.name,
      definition: field_schema.definition}
  end
end
