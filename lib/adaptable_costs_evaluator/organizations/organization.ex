defmodule AdaptableCostsEvaluator.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Organizations.Membership
  alias AdaptableCostsEvaluator.Users.User

  schema "organizations" do
    field :name, :string
    field :username, :string

    has_many :memberships, Membership
    many_to_many :users, User, join_through: "memberships"

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

  defdelegate authorize(action, user, params), to: AdaptableCostsEvaluator.Policies.Organizations.OrganizationPolicy
end
