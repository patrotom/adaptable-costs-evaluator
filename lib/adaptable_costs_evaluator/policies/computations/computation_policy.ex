defmodule AdaptableCostsEvaluator.Policies.Computations.ComputationPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.{Computations, Organizations}

  @behaviour Bodyguard.Policy

  def authorize(:list, %User{} = user, creator_id) do
    user.id == String.to_integer(creator_id)
  end

  def authorize(:organization_list, %User{} = user, organization_id) do
    Organizations.list_roles(organization_id, user.id) != []
  end

  def authorize(:create, _, _), do: true

  def authorize(:delete, %User{} = user, computation_id) do
    computation = Computations.get_computation!(computation_id)
    computation.creator_id == user.id
  end

  def authorize(:organization_delete, %User{} = user, computation_id) do
    computation = Computations.get_computation!(computation_id)

    if computation.organization_id == nil do
      computation.creator_id == user.id
    else
      computation.creator_id == user.id || executive?(user.id, computation.organization_id)
    end
  end

  def authorize(action, %User{} = user, computation_id) do
    case action do
      a when a in [:read, :update] ->
        computation = Computations.get_computation!(computation_id)

        computation.creator_id == user.id ||
          Organizations.list_roles(computation.organization_id, user.id) != []

      _ ->
        false
    end
  end
end
