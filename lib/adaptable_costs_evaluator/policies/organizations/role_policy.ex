defmodule AdaptableCostsEvaluator.Policies.Organizations.RolePolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.{Users, Organizations}
  alias AdaptableCostsEvaluator.Users.User

  @behaviour Bodyguard.Policy

  def authorize(:list, %User{} = user, organization_id) do
    Organizations.list_roles(organization_id, user.id) != []
  end

  def authorize(_, %User{} = user, %{"type" => role_type, "organization_id" => organization_id}) do
    case role_type do
      r when r in [:regular, "regular"] -> executive?(user.id, organization_id)
      _ -> Users.has_role?(:owner, user.id, organization_id)
    end
  end
end
