defmodule AdaptableCostsEvaluator.Computations.Computation do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations.Organization
  alias AdaptableCostsEvaluator.Formulas.Formula
  alias AdaptableCostsEvaluator.Inputs.Input
  alias AdaptableCostsEvaluator.Outputs.Output

  schema "computations" do
    field :name, :string

    belongs_to :user, User, foreign_key: :creator_id
    belongs_to :organization, Organization

    has_many :formulas, Formula
    has_many :inputs, Input
    has_many :outputs, Output

    timestamps()
  end

  @doc false
  def changeset(computation, attrs) do
    computation
    |> cast(attrs, [:name, :creator_id, :organization_id])
    |> validate_required([:name, :creator_id])
    |> validate_length(:name, max: 100)
  end

  defdelegate authorize(action, user, params),
    to: AdaptableCostsEvaluator.Policies.Computations.ComputationPolicy
end
