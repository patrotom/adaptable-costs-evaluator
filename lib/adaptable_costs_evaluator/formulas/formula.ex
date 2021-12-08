defmodule AdaptableCostsEvaluator.Formulas.Formula do
  @moduledoc """
  A `AdaptableCostsEvaluator.Formulas.Formula` represents an expression that
  that can be used inside the particular `AdaptableCostsEvaluator.Computations.Computation`.
  The syntax, behavior, and capability of the `AdaptableCostsEvaluator.Formulas.Formula`
  definition depends on the linked `AdaptableCostsEvaluator.Evaluators.Evaluator`.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Validators.LabelValidator

  schema "formulas" do
    field :definition, :string
    field :label, :string
    field :name, :string

    belongs_to :computation, AdaptableCostsEvaluator.Computations.Computation
    belongs_to :evaluator, AdaptableCostsEvaluator.Evaluators.Evaluator
    has_many :outputs, AdaptableCostsEvaluator.Outputs.Output

    timestamps()
  end

  @doc false
  def changeset(formula, attrs) do
    formula
    |> cast(attrs, [:name, :label, :definition, :computation_id, :evaluator_id])
    |> validate_required([:name, :label, :computation_id])
    |> validate_length(:name, max: 100)
    |> validate_length(:label, max: 100)
    |> unique_constraint([:label, :computation_id])
    |> LabelValidator.validate()
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Formulas.FormulaPolicy
end
