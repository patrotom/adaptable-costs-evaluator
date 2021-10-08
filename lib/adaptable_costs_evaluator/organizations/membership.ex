defmodule AdaptableCostsEvaluator.Organizations.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Organizations.Organization
  alias AdaptableCostsEvaluator.Users.User

  schema "memberships" do
    belongs_to :organization, Organization
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:user_id, :organization_id])
    |> validate_required([:user_id, :organization_id])
    |> unique_constraint([:user_id, :organization_id])
  end
end
