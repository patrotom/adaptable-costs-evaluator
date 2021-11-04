defmodule AdaptableCostsEvaluator.FieldSchemas.FieldSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "field_schemas" do
    field :definition, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(field_schema, attrs) do
    field_schema
    |> cast(attrs, [:name, :definition])
    |> validate_required([:name, :definition])
    |> unique_constraint(:name)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.FieldSchemas.FieldSchemaPolicy
end
