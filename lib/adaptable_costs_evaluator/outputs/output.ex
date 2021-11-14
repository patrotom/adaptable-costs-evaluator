defmodule AdaptableCostsEvaluator.Outputs.Output do
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
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Outputs.OutputPolicy
end
