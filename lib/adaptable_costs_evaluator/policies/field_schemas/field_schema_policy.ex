defmodule AdaptableCostsEvaluator.Policies.FieldSchemas.FieldSchemaPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User

  @behaviour Bodyguard.Policy

  def authorize(_, %User{} = current_user, _), do: current_user.admin
end
