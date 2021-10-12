defmodule AdaptableCostsEvaluator.Organizations.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Organizations.Membership

  schema "roles" do
    field :type, Ecto.Enum, values: [:regular, :maintainer, :owner]

    belongs_to :membership, Membership

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:type, :membership_id])
    |> validate_required([:type, :membership_id])
    |> unique_constraint([:type, :membership_id])
  end
end
