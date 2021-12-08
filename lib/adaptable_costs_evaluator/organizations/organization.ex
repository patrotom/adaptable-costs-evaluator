defmodule AdaptableCostsEvaluator.Organizations.Organization do
  @moduledoc """
  An `AdaptableCostsEvaluator.Organizations.Organization` groups multiple
  `AdaptableCostsEvaluator.Users.User`s together. The `AdaptableCostsEvaluator.Users.User`s,
  within the `AdaptableCostsEvaluator.Organizations.Organization`, can share
  the `AdaptableCostsEvaluator.Computations.Computation`s together and
  collaborate together on their development.

  `AdaptableCostsEvaluator.Users.User` can be a member of the multiple
  `AdaptableCostsEvaluator.Organizations.Organization`s. Each
  `AdaptableCostsEvaluator.Users.User` has a `AdaptableCostsEvaluator.Organizations.Role`
  within the Organization that determines the level of permissions to read and
  manipulate resources in the `AdaptableCostsEvaluator.Organizations.Organization`.
  """

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
