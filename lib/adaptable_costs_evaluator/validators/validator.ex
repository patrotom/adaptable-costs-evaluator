defmodule AdaptableCostsEvaluator.Validators.Validator do
  @moduledoc """
  An interface module that should be used to define a new validator. A single
  validator represents validation of the single attribute within the `Ecto.Changeset`.
  """

  @doc """
  Takes an `Ecto.Changeset` and performs a validation of the particular attribute.
  """
  @callback validate(Ecto.Changeset.t()) :: Ecto.Changeset.t()
end
