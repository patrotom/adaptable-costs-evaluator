defmodule AdaptableCostsEvaluator.Formulas.Formula do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Computations.Computation

  schema "formulas" do
    field :definition, :string
    field :label, :string
    field :name, :string

    belongs_to :computation, Computation

    timestamps()
  end

  @doc false
  def changeset(formula, attrs) do
    formula
    |> cast(attrs, [:name, :label, :definition, :computation_id])
    |> validate_required([:name, :label, :computation_id])
    |> validate_length(:name, max: 100)
    |> validate_length(:label, max: 100)
    |> unique_constraint([:label, :computation_id])
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Formulas.FormulaPolicy
end
