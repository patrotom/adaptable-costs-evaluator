defmodule AdaptableCostsEvaluator.Policies.Organizations.RolePolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations.Role
  alias AdaptableCostsEvaluator.{Users, Repo}

  @behaviour Bodyguard.Policy

  def authorize(:read, %User{} = user, %Role{} = role) do
    organization = organization_from_role(role)

    Users.has_role?(:regular, user.id, organization.id) ||
      executive?(user.id, organization.id)
  end

  def authorize(:delete, %User{} = user, %Role{} = role) do
    organization = organization_from_role(role)

    case role.type do
      :regular -> executive?(user.id, organization.id)
      _ -> Users.has_role?(:owner, user.id, organization.id)
    end
  end

  def authorize(_action, %User{} = user, %{
        "type" => role_type,
        "organization_id" => organization_id
      }) do
    case role_type do
      r when r in [:regular, "regular"] -> executive?(user.id, organization_id)
      _ -> Users.has_role?(:owner, user.id, organization_id)
    end
  end

  defp organization_from_role(role) do
    Repo.preload(role, membership: [:organization]).membership.organization
  end
end
