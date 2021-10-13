defmodule AdaptableCostsEvaluator.Policies.Organizations.MembershipPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User

  @behaviour Bodyguard.Policy

  def authorize(:create, %User{} = user, organization_id) do
    executive?(user.id, organization_id)
  end

  def authorize(_action, %User{} = user, membership) do
    user.id == membership.user_id ||
      executive?(user.id, membership.organization_id)
  end
end
