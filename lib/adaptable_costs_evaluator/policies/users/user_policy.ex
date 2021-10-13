defmodule AdaptableCostsEvaluator.Policies.Users.UserPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations

  @behaviour Bodyguard.Policy

  def authorize(_action, %User{id: user_id}, user_id), do: true

  def authorize(:create, _, _), do: true

  def authorize(:read, %User{} = current_user, user_id) do
    user = Users.get_user!(user_id)
    Organizations.colleagues?(current_user, user)
  end

  def authorize(_, _, _), do: false
end
