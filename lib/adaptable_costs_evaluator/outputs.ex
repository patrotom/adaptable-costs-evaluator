defmodule AdaptableCostsEvaluator.Outputs do
  @moduledoc """
  The Outputs context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.Outputs.Output
  alias AdaptableCostsEvaluator.Computations.Computation

  @doc """
  Returns the list of outputs.

  ## Examples

      iex> list_outputs()
      [%Output{}, ...]

  """
  def list_outputs(%Computation{} = computation) do
    Repo.preload(computation, :outputs).outputs
  end

  @doc """
  Gets a single output.

  Raises `Ecto.NoResultsError` if the Output does not exist.

  ## Examples

      iex> get_output!(123)
      %Output{}

      iex> get_output!(456)
      ** (Ecto.NoResultsError)

  """
  def get_output!(id, %Computation{} = computation) do
    Repo.get_by!(Output, id: id, computation_id: computation.id)
  end

  @doc """
  Creates a output.

  ## Examples

      iex> create_output(%{field: value})
      {:ok, %Output{}}

      iex> create_output(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_output(attrs \\ %{}) do
    %Output{}
    |> change_output(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a output.

  ## Examples

      iex> update_output(output, %{field: new_value})
      {:ok, %Output{}}

      iex> update_output(output, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_output(%Output{} = output, attrs) do
    output
    |> change_output(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a output.

  ## Examples

      iex> delete_output(output)
      {:ok, %Output{}}

      iex> delete_output(output)
      {:error, %Ecto.Changeset{}}

  """
  def delete_output(%Output{} = output) do
    Repo.delete(output)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking output changes.

  ## Examples

      iex> change_output(output)
      %Ecto.Changeset{data: %Output{}}

  """
  def change_output(%Output{} = output, attrs \\ %{}) do
    Output.changeset(output, attrs)
  end
end
