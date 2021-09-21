defmodule AdaptableCostsEvaluator.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Users.Credential

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :token, :string, virtual: true

    has_one :credential, Credential

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
  end
end
