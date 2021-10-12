defmodule AdaptableCostsEvaluator.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.{Repo, Guardian}

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Users.{User, Credential}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(from u in User, preload: [:credential])
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:credential)
  end

  def get_user_by_email!(email) do
    Repo.get_by!(Credential, email: email)
    |> Repo.preload(:user)
    |> then(fn credential -> credential.user.id end)
    |> get_user!()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    credential_attrs = Map.get(attrs, "credential",
                               Map.get(attrs, :credential, %{}))
    user_attrs = Map.drop(attrs, ["credential", :credential])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:credential,
                         Credential.changeset(user.credential, credential_attrs))
    |> Ecto.Multi.update(:user,
                         User.changeset(user, user_attrs))
    |> Repo.transaction()
    |> case do
      {:ok, result} -> {:ok, get_user!(result[:user].id)}
      {:error, _, value, _} -> {:error, value}
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def list_organizations(user_id) do
    user = get_user!(user_id)
    Repo.preload(user, :organizations).organizations
  end

  def has_role?(role_type, user_id, organization_id) do
    user = get_user!(user_id)
    organization = Organizations.get_organization!(organization_id)

    Organizations.list_roles(organization.id, user.id)
    |> Enum.map(fn r -> r.type end)
    |> Enum.member?(role_type)
  end

  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user)
      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    credential = try do
      get_user_by_email!(email).credential
    rescue
      Ecto.NoResultsError -> nil
    end

    if credential == nil, do: {:error, :sign_in_error}, else: verify_password(password, credential)
  end

  defp verify_password(password, %Credential{} = credential) when is_binary(password) do
    if Bcrypt.verify_pass(password, credential.password_hash) do
      {:ok, Repo.preload(credential, :user).user}
    else
      {:error, :invalid_password}
    end
  end
end
