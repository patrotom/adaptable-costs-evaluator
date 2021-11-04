defmodule AdaptableCostsEvaluator.Computations.Computation do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations.Organization
  alias AdaptableCostsEvaluator.Formulas.Formula

  schema "computations" do
    field :name, :string

    belongs_to :user, User, foreign_key: :creator_id
    belongs_to :organization, Organization

    has_many :formulas, Formula

    timestamps()
  end

  @doc false
  def changeset(computation, attrs) do
    computation
    |> cast(attrs, [:name, :creator_id, :organization_id])
    |> validate_required([:name, :creator_id])
    |> validate_length(:name, min: 1)
    |> validate_length(:name, max: 255)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Computations.ComputationPolicy
end
