defmodule AdaptableCostsEvaluator.Users.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Users

  schema "credentials" do
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[^@]+@[^@]+$/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        ->
          put_change(changeset, :password_hash, Users.hash_password(password))
      _
        ->
          changeset
    end
  end
end
