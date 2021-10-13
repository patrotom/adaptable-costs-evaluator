defmodule AdaptableCostsEvaluator.Policies.Users.UserPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations

  @behaviour Bodyguard.Policy

  def authorize(_action, %User{id: user_id}, %User{id: user_id}), do: true

  def authorize(:create, %User{}, _params), do: true

  def authorize(action, %User{} = current_user, %User{} = user) do
    case action do
      :read -> Organizations.colleagues?(current_user, user)
      _ -> false
    end
  end
end
