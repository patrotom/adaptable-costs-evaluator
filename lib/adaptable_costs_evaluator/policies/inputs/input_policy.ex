defmodule AdaptableCostsEvaluator.Policies.Inputs.InputPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Computations.Computation
  alias AdaptableCostsEvaluator.Users.User

  @behaviour Bodyguard.Policy

  def authorize(_, %User{} = user, %Computation{} = computation) do
    Bodyguard.permit(Computation, :read, user, computation.id)
  end
end
