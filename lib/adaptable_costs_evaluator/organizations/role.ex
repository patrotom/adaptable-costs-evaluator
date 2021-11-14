defmodule AdaptableCostsEvaluator.Organizations.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :type, Ecto.Enum, values: [:regular, :maintainer, :owner]

    belongs_to :membership, AdaptableCostsEvaluator.Organizations.Membership

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:type, :membership_id])
    |> validate_required([:type])
    |> unique_constraint([:type, :membership_id])
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Organizations.RolePolicy
end
