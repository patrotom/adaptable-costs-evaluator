defmodule AdaptableCostsEvaluator.Computations.Computation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "computations" do
    field :name, :string

    belongs_to :user, AdaptableCostsEvaluator.Users.User, foreign_key: :creator_id
    belongs_to :organization, AdaptableCostsEvaluator.Organizations.Organization

    has_many :formulas, AdaptableCostsEvaluator.Formulas.Formula
    has_many :inputs, AdaptableCostsEvaluator.Inputs.Input
    has_many :outputs, AdaptableCostsEvaluator.Outputs.Output

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
