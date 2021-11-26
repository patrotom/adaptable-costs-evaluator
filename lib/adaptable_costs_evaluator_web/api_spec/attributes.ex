defmodule AdaptableCostsEvaluatorWeb.ApiSpec.Attributes do
  alias OpenApiSpex.Schema

  def id() do
    %Schema{type: :integer, description: "Unique identifier"}
  end

  def organization_id() do
    %Schema{type: :integer, description: "ID of the Organization"}
  end
end
