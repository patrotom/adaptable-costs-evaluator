defmodule AdaptableCostsEvaluator.Policies.Formulas.FormulaPolicy do
  use AdaptableCostsEvaluator.Policies.BasePolicy

  alias AdaptableCostsEvaluator.Computations.Computation
  alias AdaptableCostsEvaluator.Users.User

  alias AdaptableCostsEvaluator.Policies.Computations.ComputationPolicy

  @behaviour Bodyguard.Policy

  def authorize(_, %User{} = user, %Computation{} = computation) do
    ComputationPolicy.authorize(:read, user, computation.id)
  end
end
