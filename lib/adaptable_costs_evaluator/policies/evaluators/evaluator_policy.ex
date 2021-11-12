defmodule AdaptableCostsEvaluator.Policies.Evaluators.EvaluatorPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Users.User

  @behaviour Bodyguard.Policy

  def authorize(action, %User{} = current_user, _) do
    case action do
      a when a in [:read, :list] -> true
      _ -> current_user.admin
    end
  end
end
