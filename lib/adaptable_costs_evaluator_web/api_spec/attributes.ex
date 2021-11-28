defmodule AdaptableCostsEvaluatorWeb.ApiSpec.Attributes do
  alias OpenApiSpex.Schema

  def id() do
    construct_id("Unique identifier")
  end

  def organization_id() do
    construct_id("ID of the Organization")
  end

  def computation_id() do
    construct_id("ID of the Computation")
  end

  def field_schema_id() do
    construct_id("ID of the FieldSchema used to validate the last_value")
  end

  def formula_id() do
    construct_id("ID of the Formula that yields the result of the evaluation")
  end

  defp construct_id(description, type \\ :integer) do
    %Schema{type: type, description: description}
  end
end
