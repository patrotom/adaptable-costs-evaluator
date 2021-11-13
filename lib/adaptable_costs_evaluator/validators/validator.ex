defmodule AdaptableCostsEvaluator.Validators.Validator do
  @callback validate(Ecto.Changeset.t()) :: Ecto.Changeset.t()
end
