defmodule AdaptableCostsEvaluator.Users.Credential do
  @moduledoc """
  A `AdaptableCostsEvaluator.Users.Credential` record holds authentication details
  of the particular `AdaptableCostsEvaluator.Users.User`.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias AdaptableCostsEvaluator.Users

  schema "credentials" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    belongs_to :user, AdaptableCostsEvaluator.Users.User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^@]+@[^@]+$/)
    |> unique_constraint(:email)
    |> validate_password()
    |> put_password_hash()
  end

  defp validate_password(changeset) do
    cond do
      changeset.data.password_hash == nil ->
        changeset
        |> validate_required([:password])
        |> validate_length(:password, min: 8)

      changeset.changes[:password] != nil ->
        changeset
        |> validate_length(:password, min: 8)

      true ->
        changeset
    end
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Users.hash_password(password))

      _ ->
        changeset
    end
  end
end
