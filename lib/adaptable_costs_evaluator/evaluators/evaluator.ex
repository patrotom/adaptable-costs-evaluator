defmodule AdaptableCostsEvaluator.Evaluators.Evaluator do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Formulas.Formula

  schema "evaluators" do
    field :description, :string
    field :module, :string
    field :name, :string

    has_many :formulas, Formula

    timestamps()
  end

  @doc false
  def changeset(evaluator, attrs) do
    evaluator
    |> cast(attrs, [:name, :description, :module])
    |> validate_required([:name, :module])
    |> unique_constraint(:name)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Evaluators.EvaluatorPolicy
end
