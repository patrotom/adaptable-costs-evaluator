defmodule AdaptableCostsEvaluator.Inputs.Input do
  @moduledoc """
  An `AdaptableCostsEvaluator.Inputs.Input` holds the input data provided by the client.
  The value of the `AdaptableCostsEvaluator.Inputs.Input` is always validated against
  the linked `AdaptableCostsEvaluator.FieldSchemas.FieldSchema`.
  The `AdaptableCostsEvaluator.Inputs.Input` can be seen as a variable which
  can hold data of the type determined by the linked
  `AdaptableCostsEvaluator.FieldSchemas.FieldSchema`.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Validators.{FieldValueValidator, LabelValidator}

  schema "inputs" do
    field :label, :string
    field :last_value, AdaptableCostsEvaluator.Types.JSONB
    field :name, :string

    belongs_to :computation, AdaptableCostsEvaluator.Computations.Computation
    belongs_to :field_schema, AdaptableCostsEvaluator.FieldSchemas.FieldSchema

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
    |> FieldValueValidator.validate()
    |> LabelValidator.validate()
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Inputs.InputPolicy
end
