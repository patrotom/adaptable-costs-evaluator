defmodule AdaptableCostsEvaluator.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :username, :string

    has_many :memberships, AdaptableCostsEvaluator.Organizations.Membership
    has_many :computations, AdaptableCostsEvaluator.Computations.Computation
    many_to_many :users, AdaptableCostsEvaluator.Users.User, join_through: "memberships"

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
    |> validate_length(:name, max: 100)
    |> validate_length(:username, max: 100)
    |> validate_format(:username, ~r/^[a-zA-Z0-9\.\_\-]+$/)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Organizations.OrganizationPolicy
end
