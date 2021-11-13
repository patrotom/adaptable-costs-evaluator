defmodule AdaptableCostsEvaluator.Evaluators do
  @moduledoc """
  The Evaluators context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.Evaluators.Evaluator

  @doc """
  Returns the list of evaluators.

  ## Examples

      iex> list_evaluators()
      [%Evaluator{}, ...]

  """
  def list_evaluators do
    Repo.all(Evaluator)
  end

  @doc """
  Gets a single evaluator.

  Raises `Ecto.NoResultsError` if the Evaluator does not exist.

  ## Examples

      iex> get_evaluator!(123)
      %Evaluator{}

      iex> get_evaluator!(456)
      ** (Ecto.NoResultsError)

  """
  def get_evaluator!(id), do: Repo.get!(Evaluator, id)

  @doc """
  Creates a evaluator.

  ## Examples

      iex> create_evaluator(%{field: value})
      {:ok, %Evaluator{}}

      iex> create_evaluator(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_evaluator(attrs \\ %{}) do
    %Evaluator{}
    |> Evaluator.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a evaluator.

  ## Examples

      iex> update_evaluator(evaluator, %{field: new_value})
      {:ok, %Evaluator{}}

      iex> update_evaluator(evaluator, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_evaluator(%Evaluator{} = evaluator, attrs) do
    evaluator
    |> Evaluator.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a evaluator.

  ## Examples

      iex> delete_evaluator(evaluator)
      {:ok, %Evaluator{}}

      iex> delete_evaluator(evaluator)
      {:error, %Ecto.Changeset{}}

  """
  def delete_evaluator(%Evaluator{} = evaluator) do
    Repo.delete(evaluator)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking evaluator changes.

  ## Examples

      iex> change_evaluator(evaluator)
      %Ecto.Changeset{data: %Evaluator{}}

  """
  def change_evaluator(%Evaluator{} = evaluator, attrs \\ %{}) do
    Evaluator.changeset(evaluator, attrs)
  end
end
