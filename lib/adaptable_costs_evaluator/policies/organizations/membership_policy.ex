defmodule AdaptableCostsEvaluator.Policies.Organizations.MembershipPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.User

  @behaviour Bodyguard.Policy

  def authorize(:create, %User{} = user, organization_id) do
    executive?(user.id, organization_id)
  end

  def authorize(:list, %User{} = user, organization_id) do
    Users.has_role?(:regular, user.id, organization_id) ||
      executive?(user.id, organization_id)
  end

  def authorize(:delete, %User{} = user, %{
        "user_id" => user_id,
        "organization_id" => organization_id
      }) do
    user.id == user_id ||
      (executive?(user.id, organization_id) &&
         !(Users.has_role?(:owner, user_id, organization_id) ||
             Users.has_role?(:maintainer, user_id, organization_id)))
  end
end
