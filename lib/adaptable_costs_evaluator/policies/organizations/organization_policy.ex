defmodule AdaptableCostsEvaluator.Policies.Organizations.OrganizationPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Users

  @behaviour Bodyguard.Policy

  def authorize(:read, %User{} = user, organization) do
    Users.has_role?(:regular, user.id, organization.id) ||
      executive?(user.id, organization.id)
  end

  def authorize(:create, %User{}, _params), do: true

  def authorize(:update, %User{} = user, organization) do
    executive?(user.id, organization.id)
  end

  def authorize(:delete, %User{} = user, organization) do
    Users.has_role?(:owner, user.id, organization.id)
  end
end
