defmodule AdaptableCostsEvaluator.Policies.Organizations.OrganizationPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.{Users, Organizations}

  @behaviour Bodyguard.Policy

  def authorize(:read, %User{} = user, organization_id) do
    Organizations.list_roles(organization_id, user.id) != []
  end

  def authorize(:create, %User{}, _), do: true

  def authorize(:update, %User{} = user, organization_id) do
    executive?(user.id, organization_id)
  end

  def authorize(:delete, %User{} = user, organization_id) do
    Users.has_role?(:owner, user.id, organization_id)
  end

  def authorize(_, _, _), do: false
end
