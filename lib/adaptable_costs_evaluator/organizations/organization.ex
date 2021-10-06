defmodule AdaptableCostsEvaluator.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
    |> validate_format(:username, ~r/^[a-zA-Z0-9\.\_\-]+$/)
  end
end
