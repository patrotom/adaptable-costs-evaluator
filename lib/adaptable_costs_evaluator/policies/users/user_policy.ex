defmodule AdaptableCostsEvaluator.Policies.Users.UserPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations

  @behaviour Bodyguard.Policy

  def authorize(:update_admin, %User{} = current_user, params) do
    if params["admin"] == nil && params[:admin] == nil do
      true
    else
      current_user.admin
    end
  end

  def authorize(:create, _, _), do: true

  def authorize(action, %User{} = current_user, user_id) do
    if user_id == current_user.id do
      true
    else
      _authorize(action, current_user, user_id)
    end
  end

  defp _authorize(:read, %User{} = current_user, user_id) do
    user = Users.get_user!(user_id)
    Organizations.colleagues?(current_user, user)
  end

  defp _authorize(_, _, _), do: false
end
