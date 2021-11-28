defmodule AdaptableCostsEvaluatorWeb.ApiSpec.Parameters do
  def id() do
    construct_id(:id, "Unique identifier")
  end

  def organization_id() do
    construct_id(:organization_id, "ID of the Organization")
  end

  def user_id() do
    construct_id(:user_id, "ID of the User")
  end

  def computation_id() do
    construct_id(:computation_id, "ID of the Computation")
  end

  defp construct_id(name, description, location \\ :path, type \\ :integer, example \\ 42) do
    {name, [in: location, type: type, description: description, example: example]}
  end
end
