defmodule AdaptableCostsEvaluator.Computations do
  @moduledoc """
  The Computations context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.Computations.Computation
  alias AdaptableCostsEvaluator.{Users, Organizations}

  def list_computations(%{creator_id: creator_id}) do
    user = Users.get_user!(creator_id)
    Repo.preload(user, :computations).computations
  end

  def list_computations(%{organization_id: organization_id}) do
    organization = Organizations.get_organization!(organization_id)
    Repo.preload(organization, :computations).computations
  end

  @doc """
  Gets a single computation.

  Raises `Ecto.NoResultsError` if the Computation does not exist.

  ## Examples

      iex> get_computation!(123)
      %Computation{}

      iex> get_computation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_computation!(id), do: Repo.get!(Computation, id)

  @doc """
  Creates a computation.

  ## Examples

      iex> create_computation(%{field: value})
      {:ok, %Computation{}}

      iex> create_computation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_computation(attrs \\ %{}) do
    %Computation{}
    |> Computation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a computation.

  ## Examples

      iex> update_computation(computation, %{field: new_value})
      {:ok, %Computation{}}

      iex> update_computation(computation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_computation(%Computation{} = computation, attrs) do
    computation
    |> Computation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a computation.

  ## Examples

      iex> delete_computation(computation)
      {:ok, %Computation{}}

      iex> delete_computation(computation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_computation(%Computation{} = computation) do
    Repo.delete(computation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking computation changes.

  ## Examples

      iex> change_computation(computation)
      %Ecto.Changeset{data: %Computation{}}

  """
  def change_computation(%Computation{} = computation, attrs \\ %{}) do
    Computation.changeset(computation, attrs)
  end
end