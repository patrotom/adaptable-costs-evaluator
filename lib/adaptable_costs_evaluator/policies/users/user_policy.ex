defmodule AdaptableCostsEvaluator.Policies.Users.UserPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations

  @behaviour Bodyguard.Policy

  def authorize(action, %User{} = current_user, user_id) do
    if String.to_integer(user_id) == current_user.id do
      true
    else
      _authorize(action, current_user, user_id)
    end
  end

  defp _authorize(:read, %User{} = current_user, user_id) do
    user = Users.get_user!(user_id)
    Organizations.colleagues?(current_user, user)
  end

  defp _authorize(:create, _, _), do: true

  defp _authorize(_, _, _), do: false
end
