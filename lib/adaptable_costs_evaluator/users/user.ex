defmodule AdaptableCostsEvaluator.Users.User do
  @moduledoc """
  A `AdaptableCostsEvaluator.Users.User` represents a concrete user/account
  within the application. Most of the endpoints require authenticated
  `AdaptableCostsEvaluator.Users.User` in order to work with them.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Organizations.{Organization, Membership}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :admin, :boolean
    field :token, :string, virtual: true

    has_one :credential, AdaptableCostsEvaluator.Users.Credential
    has_many :memberships, Membership

    has_many :computations, AdaptableCostsEvaluator.Computations.Computation,
      foreign_key: :creator_id

    many_to_many :organizations, Organization, join_through: "memberships"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :middle_name, :last_name, :admin])
    |> validate_required([:first_name, :last_name])
    |> validate_length(:first_name, max: 50)
    |> validate_length(:middle_name, max: 50)
    |> validate_length(:last_name, max: 50)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Users.UserPolicy
end
