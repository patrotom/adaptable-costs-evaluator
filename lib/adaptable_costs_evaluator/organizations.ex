defmodule AdaptableCostsEvaluator.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Organizations.{Organization, Membership, Role}

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    Repo.all(Organization)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id), do: Repo.get!(Organization, id)

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> change_organization(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> change_organization(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end

  @doc """
  Returns the list of users in the organization.
  """
  def list_users(organization_id) do
    organization = Repo.get!(Organization, organization_id)
    Repo.preload(organization, users: [:credential]).users
  end

  @doc """
  Returns the membership of the user in the organization.
  """
  def get_membership!(organization_id, user_id) do
    Repo.get_by!(Membership,
      organization_id: organization_id,
      user_id: user_id
    )
  end

  @doc """
  Creates a new membership for the user in the given organization.

  It also creates a default regular role alongside it.
  """
  def create_membership(organization_id, user_id) do
    organization = get_organization!(organization_id)
    user = Users.get_user!(user_id)

    attrs = %{
      organization_id: organization.id,
      user_id: user.id,
      roles: [%{type: :regular}]
    }

    %Membership{}
    |> change_membership(attrs)
    |> Ecto.Changeset.cast_assoc(:roles, with: &Role.changeset/2)
    |> Repo.insert()
  end

  @doc """
  Deletes the membership of the user in the organization.
  """
  def delete_membership(organization_id, user_id) do
    membership =
      Repo.get_by!(Membership,
        organization_id: organization_id,
        user_id: user_id
      )

    Repo.delete(membership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking membership changes.

  ## Examples

      iex> change_membership(membership)
      %Ecto.Changeset{data: %Membership{}}

  """
  def change_membership(%Membership{} = membership, attrs \\ %{}) do
    Membership.changeset(membership, attrs)
  end

  @doc """
  Determines whether two users have a membership in at least one mutual organization.
  """
  @spec colleagues?(%User{}, %User{}) :: boolean
  def colleagues?(%User{} = first_user, %User{} = second_user) do
    first_user_organizations = Users.list_organizations(first_user.id)
    second_user_organizations = Users.list_organizations(second_user.id)

    if first_user_organizations == [] || second_user_organizations == [] do
      false
    else
      len_before = length(first_user_organizations)
      diff = first_user_organizations -- second_user_organizations

      len_before != length(diff)
    end
  end

  @doc """
  List roles of the user in the organization.
  """
  def list_roles(organization_id, user_id) do
    membership =
      Repo.get_by(Membership,
        organization_id: organization_id,
        user_id: user_id
      )

    if membership == nil do
      []
    else
      Repo.preload(membership, :roles).roles
    end
  end

  @doc """
  Creates a new role for the user in the organization if the user is a member of
  the organization.
  """
  def create_role(organization_id, user_id, attrs) do
    membership = get_membership!(organization_id, user_id)
    attrs = Map.merge(attrs, %{"membership_id" => membership.id})

    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a role of the user in the organization if the user is a member of the
  organization and if the role exists.
  """
  def delete_role(role_type, organization_id, user_id) do
    membership =
      get_membership!(organization_id, user_id)
      |> Repo.preload(roles: from(r in Role, where: r.type == ^role_type))

    role = List.first(membership.roles)

    if role == nil do
      {:error, :not_found}
    else
      Repo.delete(role)
    end
  end
end
