defmodule AdaptableCostsEvaluator.Outputs.Output do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Computations.Computation
  alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema
  alias AdaptableCostsEvaluator.Formulas.Formula

  schema "outputs" do
    field :label, :string
    field :last_value, :map
    field :name, :string

    belongs_to :computation, Computation
    belongs_to :field_schema, FieldSchema
    belongs_to :formula, Formula

    timestamps()
  end

  @doc false
  def changeset(output, attrs) do
    output
    |> cast(attrs, [:name, :label, :last_value, :computation_id, :field_schema_id])
    |> validate_required([:name, :label, :computation_id, :field_schema_id])
    |> validate_length(:name, max: 100)
    |> validate_length(:label, max: 100)
    |> unique_constraint([:label, :computation_id])
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Outputs.OutputPolicy
end