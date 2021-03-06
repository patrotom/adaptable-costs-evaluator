defmodule AdaptableCostsEvaluator.Outputs.Output do
  @moduledoc """
  An `AdaptableCostsEvaluator.Outputs.Output` holds the result of the evaluation
  of the particular `AdaptableCostsEvaluator.Formulas.Formula`. The value of the
  `AdaptableCostsEvaluator.Outputs.Output` is always validated against the linked
  `AdaptableCostsEvaluator.FieldSchemas.FieldSchema`.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Validators.{FieldValueValidator, LabelValidator}

  schema "outputs" do
    field :label, :string
    field :last_value, AdaptableCostsEvaluator.Types.JSONB
    field :name, :string

    belongs_to :computation, AdaptableCostsEvaluator.Computations.Computation
    belongs_to :field_schema, AdaptableCostsEvaluator.FieldSchemas.FieldSchema
    belongs_to :formula, AdaptableCostsEvaluator.Formulas.Formula

    timestamps()
  end

  @doc false
  def changeset(output, attrs) do
    output
    |> cast(attrs, [:name, :label, :last_value, :computation_id, :field_schema_id, :formula_id])
    |> validate_required([:name, :label, :computation_id, :field_schema_id])
    |> validate_length(:name, max: 100)
    |> validate_length(:label, max: 100)
    |> unique_constraint([:label, :computation_id])
    |> FieldValueValidator.validate()
    |> LabelValidator.validate()
    |> validate_computation_context()
  end

  defp validate_computation_context(changeset) do
    if changeset.valid? do
      changes = changeset.changes
      formula_id = changes[:formula_id] || changeset.data.formula_id
      computation_id = changes[:computation_id] || changeset.data.computation_id

      if formula_id == nil do
        changeset
      else
        formula = AdaptableCostsEvaluator.Formulas.get_formula!(formula_id)

        if formula.computation_id == computation_id do
          changeset
        else
          add_error(
            changeset,
            :formula_id,
            "formula is in different computation than the output record"
          )
        end
      end
    else
      changeset
    end
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Outputs.OutputPolicy
end
