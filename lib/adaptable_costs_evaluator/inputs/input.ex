defmodule AdaptableCostsEvaluator.Inputs.Input do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Computations.Computation
  alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

  schema "inputs" do
    field :label, :string
    field :last_value, :map
    field :name, :string

    belongs_to :computation, Computation
    belongs_to :field_schema, FieldSchema

    timestamps()
  end

  @doc false
  def changeset(input, attrs) do
    input
    |> cast(attrs, [:name, :label, :last_value, :computation_id, :field_schema_id])
    |> validate_required([:name, :label, :computation_id, :field_schema_id])
    |> validate_length(:name, max: 100)
    |> validate_length(:label, max: 100)
    |> unique_constraint([:label, :computation_id])
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Inputs.InputPolicy
end
