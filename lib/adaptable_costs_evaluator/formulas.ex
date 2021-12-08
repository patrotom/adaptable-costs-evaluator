defmodule AdaptableCostsEvaluator.Formulas do
  @moduledoc """
  The Formulas context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.Outputs
  alias AdaptableCostsEvaluator.Formulas.Formula
  alias AdaptableCostsEvaluator.Computations.Computation

  @doc """
  Returns the list of formulas in the computation.

  ## Examples

      iex> list_formulas(computation)
      [%Formula{}, ...]

  """
  def list_formulas(%Computation{} = computation) do
    Repo.preload(computation, :formulas).formulas
  end

  @doc """
  Gets a single formula from the computation.

  Raises `Ecto.NoResultsError` if the Formula does not exist.

  ## Examples

      iex> get_formula!(123, computation)
      %Formula{}

      iex> get_formula!(456, computation)
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
    |> change_formula(attrs)
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
    |> change_formula(attrs)
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

  @doc """
  Runs the evaluation of the formula.

  It evaluates the formula using the linked evaluator. Returns a map with the
  result and affected outputs where the `last_value` attribute has been updated.
  """
  @spec evaluate_formula(%AdaptableCostsEvaluator.Formulas.Formula{}) ::
          {:error, {:unprocessable_entity, [...]}}
          | {:ok, %{outputs: list, result: any}}
  def evaluate_formula(%Formula{evaluator_id: nil}) do
    {:error, "evaluator not specified"}
  end

  def evaluate_formula(%Formula{} = formula) do
    evaluator = Repo.preload(formula, :evaluator).evaluator
    result = apply(String.to_existing_atom("Elixir.#{evaluator.module}"), :evaluate, [formula])

    case result do
      {:ok, value} ->
        attrs = %{
          outputs: apply_result_to_outputs(formula, value),
          result: value
        }

        {:ok, attrs}

      {:error, error} ->
        {:error, {:unprocessable_entity, [error]}}
    end
  end

  defp apply_result_to_outputs(%Formula{} = formula, result) do
    Repo.preload(formula, :outputs).outputs
    |> Enum.map(fn o ->
      case Outputs.update_output(o, %{last_value: result}) do
        {:ok, output} -> output
        {:error, _} -> nil
      end
    end)
    |> Enum.filter(fn o -> o != nil end)
  end
end
