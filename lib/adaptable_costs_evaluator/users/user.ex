defmodule AdaptableCostsEvaluator.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Users.Credential
  alias AdaptableCostsEvaluator.Organizations.{Organization, Membership}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :admin, :boolean
    field :token, :string, virtual: true

    has_one :credential, Credential
    has_many :memberships, Membership
    many_to_many :organizations, Organization, join_through: "memberships"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :middle_name, :last_name])
    |> validate_required([:first_name, :last_name])
    |> validate_length(:first_name, min: 1)
    |> validate_length(:first_name, max: 50)
    |> validate_length(:middle_name, max: 50)
    |> validate_length(:last_name, min: 1)
    |> validate_length(:last_name, max: 50)
    |> put_admin()
  end

  defp put_admin(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{admin: _admin}}
        ->
          changeset
      _
        ->
          put_change(changeset, :admin, false)
    end
  end

  defdelegate authorize(action, user, params), to: AdaptableCostsEvaluator.Policies.Users.UserPolicy
end
