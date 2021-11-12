defmodule AdaptableCostsEvaluator.Formulas do
  @moduledoc """
  The Formulas context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.Formulas.Formula
  alias AdaptableCostsEvaluator.Computations.Computation

  @doc """
  Returns the list of formulas.

  ## Examples

      iex> list_formulas()
      [%Formula{}, ...]

  """
  def list_formulas(%Computation{} = computation) do
    Repo.preload(computation, :formulas).formulas
  end

  @doc """
  Gets a single formula.

  Raises `Ecto.NoResultsError` if the Formula does not exist.

  ## Examples

      iex> get_formula!(123)
      %Formula{}

      iex> get_formula!(456)
      ** (Ecto.NoResultsError)

  """
  def get_formula!(id, %Computation{} = computation) do
    Repo.get_by!(Formula, id: id, computation_id: computation.id)
  end

  @doc """
  Creates a formula.

  ## Examples

      iex> create_formula(%{field: value})
      {:ok, %Formula{}}

      iex> create_formula(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_formula(attrs \\ %{}) do
    %Formula{}
    |> Formula.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a formula.

  ## Examples

      iex> update_formula(formula, %{field: new_value})
      {:ok, %Formula{}}

      iex> update_formula(formula, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_formula(%Formula{} = formula, attrs) do
    formula
    |> Formula.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a formula.

  ## Examples

      iex> delete_formula(formula)
      {:ok, %Formula{}}

      iex> delete_formula(formula)
      {:error, %Ecto.Changeset{}}

  """
  def delete_formula(%Formula{} = formula) do
    Repo.delete(formula)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking formula changes.

  ## Examples

      iex> change_formula(formula)
      %Ecto.Changeset{data: %Formula{}}

  """
  def change_formula(%Formula{} = formula, attrs \\ %{}) do
    Formula.changeset(formula, attrs)
  end
end