defmodule AdaptableCostsEvaluator.FieldSchemas.FieldSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Inputs.Input

  schema "field_schemas" do
    field :definition, :map
    field :name, :string

    has_many :inputs, Input

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
