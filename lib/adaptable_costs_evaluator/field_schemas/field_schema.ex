defmodule AdaptableCostsEvaluator.FieldSchemas.FieldSchema do
  @moduledoc """
  A `AdaptableCostsEvaluator.FieldSchemas.FieldSchema` is any JSON schema that
  can be used to validate a value of the `AdaptableCostsEvaluator.Inputs.Input`
  or `AdaptableCostsEvaluator.Outputs.Output` against.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "field_schemas" do
    field :definition, :map
    field :name, :string

    has_many :inputs, AdaptableCostsEvaluator.Inputs.Input
    has_many :outputs, AdaptableCostsEvaluator.Outputs.Output

    timestamps()
  end

  @doc false
  def changeset(field_schema, attrs) do
    field_schema
    |> cast(attrs, [:name, :definition])
    |> validate_required([:name, :definition])
    |> unique_constraint(:name)
    |> validate_length(:name, max: 100)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.FieldSchemas.FieldSchemaPolicy
end
