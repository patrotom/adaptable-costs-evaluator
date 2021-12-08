defmodule AdaptableCostsEvaluator.Evaluators.Evaluator do
  @moduledoc """
  An `AdaptableCostsEvaluator.Evaluators.Evaluator` is the concrete implementation
  of a `AdaptableCostsEvaluator.Formulas.Formula` evaluator that is capable
  of reading the definition of the `AdaptableCostsEvaluator.Formulas.Formula`
  and evaluating it.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Formulas.Formula

  @implementations [
    "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator"
  ]

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
    |> validate_length(:description, max: 2000)
    |> validate_module()
  end

  @doc """
  Checks if the implementation of the evaluator module exists.

  The existing implementations are stored in the `@implementations` `List`.
  """
  @spec validate_module(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_module(changeset) do
    validate_change(changeset, :module, fn :module, module ->
      if !Enum.member?(@implementations, module) do
        [module: "does not exist"]
      else
        []
      end
    end)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Evaluators.EvaluatorPolicy

  @doc """
  Evaluates given `AdaptableCostsEvaluator.Formulas.Formula` by using a particular
  evaluator implementation.
  """
  @callback evaluate(%Formula{}) :: any()
end
