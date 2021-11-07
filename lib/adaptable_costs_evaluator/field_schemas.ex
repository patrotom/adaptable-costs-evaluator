defmodule AdaptableCostsEvaluator.FieldSchemas do
  @moduledoc """
  The FieldSchemas context.
  """

  import Ecto.Query, warn: false
  alias AdaptableCostsEvaluator.Repo

  alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

  @doc """
  Returns the list of field_schemas.

  ## Examples

      iex> list_field_schemas()
      [%FieldSchema{}, ...]

  """
  def list_field_schemas do
    Repo.all(FieldSchema)
  end

  @doc """
  Gets a single field_schema.

  Raises `Ecto.NoResultsError` if the Field schema does not exist.

  ## Examples

      iex> get_field_schema!(123)
      %FieldSchema{}

      iex> get_field_schema!(456)
      ** (Ecto.NoResultsError)

  """
  def get_field_schema!(id), do: Repo.get!(FieldSchema, id)

  @doc """
  Creates a field_schema.

  ## Examples

      iex> create_field_schema(%{field: value})
      {:ok, %FieldSchema{}}

      iex> create_field_schema(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_field_schema(attrs \\ %{}) do
    %FieldSchema{}
    |> FieldSchema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a field_schema.

  ## Examples

      iex> update_field_schema(field_schema, %{field: new_value})
      {:ok, %FieldSchema{}}

      iex> update_field_schema(field_schema, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_field_schema(%FieldSchema{} = field_schema, attrs) do
    field_schema
    |> FieldSchema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a field_schema.

  ## Examples

      iex> delete_field_schema(field_schema)
      {:ok, %FieldSchema{}}

      iex> delete_field_schema(field_schema)
      {:error, %Ecto.Changeset{}}

  """
  def delete_field_schema(%FieldSchema{} = field_schema) do
    Repo.delete(field_schema)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking field_schema changes.

  ## Examples

      iex> change_field_schema(field_schema)
      %Ecto.Changeset{data: %FieldSchema{}}

  """
  def change_field_schema(%FieldSchema{} = field_schema, attrs \\ %{}) do
    FieldSchema.changeset(field_schema, attrs)
  end
end
