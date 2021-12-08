defmodule AdaptableCostsEvaluator.Inputs do
  @moduledoc """
  The Inputs context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.Inputs.Input
  alias AdaptableCostsEvaluator.Computations.Computation

  @doc """
  Returns the list of inputs in the computation.

  ## Examples

      iex> list_inputs(computation)
      [%Input{}, ...]

  """
  def list_inputs(%Computation{} = computation) do
    Repo.preload(computation, :inputs).inputs
  end

  @doc """
  Gets a single input from the computation.

  Raises `Ecto.NoResultsError` if the Input does not exist.

  ## Examples

      iex> get_input!(123, computation)
      %Input{}

      iex> get_input!(456, computation)
      ** (Ecto.NoResultsError)

  """
  def get_input!(id, %Computation{} = computation) do
    Repo.get_by!(Input, id: id, computation_id: computation.id)
  end

  @doc """
  Gets a single input defined by the given `attrs`.
  """
  def get_by(attrs \\ []) do
    Repo.get_by(Input, attrs)
  end

  @doc """
  Creates an input.

  ## Examples

      iex> create_input(%{field: value})
      {:ok, %Input{}}

      iex> create_input(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_input(attrs \\ %{}) do
    %Input{}
    |> change_input(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an input.

  ## Examples

      iex> update_input(input, %{field: new_value})
      {:ok, %Input{}}

      iex> update_input(input, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_input(%Input{} = input, attrs) do
    input
    |> change_input(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an input.

  ## Examples

      iex> delete_input(input)
      {:ok, %Input{}}

      iex> delete_input(input)
      {:error, %Ecto.Changeset{}}

  """
  def delete_input(%Input{} = input) do
    Repo.delete(input)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking input changes.

  ## Examples

      iex> change_input(input)
      %Ecto.Changeset{data: %Input{}}

  """
  def change_input(%Input{} = input, attrs \\ %{}) do
    Input.changeset(input, attrs)
  end
end
