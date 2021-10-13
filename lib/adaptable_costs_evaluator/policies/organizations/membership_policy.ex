defmodule AdaptableCostsEvaluator.Policies.Organizations.MembershipPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User

  @behaviour Bodyguard.Policy

  def authorize(:create, %User{} = user, organization_id) do
    executive?(user.id, organization_id)
  end

  def authorize(_action, %User{} = user, %{
        "user_id" => user_id,
        "organization_id" => organization_id
      }) do
    user.id == user_id || executive?(user.id, organization_id)
  end
end
