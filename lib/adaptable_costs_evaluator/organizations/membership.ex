defmodule AdaptableCostsEvaluator.Organizations.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "memberships" do
    belongs_to :organization, AdaptableCostsEvaluator.Organizations.Organization
    belongs_to :user, AdaptableCostsEvaluator.Users.User

    has_many :roles, AdaptableCostsEvaluator.Organizations.Role

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:user_id, :organization_id])
    |> validate_required([:user_id, :organization_id])
    |> unique_constraint([:user_id, :organization_id])
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Organizations.MembershipPolicy
end
