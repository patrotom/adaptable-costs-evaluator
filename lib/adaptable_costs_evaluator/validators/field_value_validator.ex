defmodule AdaptableCostsEvaluator.Validators.FieldValueValidator do
  @behaviour AdaptableCostsEvaluator.Validators.Validator

  alias AdaptableCostsEvaluator.{Repo, FieldSchemas}

  def validate(changeset) do
    changes = changeset.changes

    schema =
      if changes[:field_schema_id] != nil do
        FieldSchemas.get_field_schema!(changes[:field_schema_id])
      else
        Repo.preload(changeset.data, :field_schema).field_schema
      end

    cond do
      changes[:last_value] != nil ->
        validate_last_value_change(changeset, schema)

      changeset.data.last_value != nil && changes[:field_schema_id] != nil ->
        validate_field_schema_change(changeset, schema)

      true ->
        changeset
    end
  end

  defp validate_last_value_change(changeset, schema) do
    Ecto.Changeset.validate_change(changeset, :last_value, fn :last_value, value ->
      case ExJsonSchema.Validator.validate(schema.definition, value) do
        :ok ->
          []

        {:error, errors} ->
          Enum.map(errors, fn {m, a} -> {:last_value, "#{a} => #{m}"} end)
      end
    end)
  end

  defp validate_field_schema_change(changeset, schema) do
    Ecto.Changeset.validate_change(changeset, :field_schema_id, fn :field_schema_id, _ ->
      case ExJsonSchema.Validator.validate(schema.definition, changeset.data.last_value) do
        :ok ->
          []

        {:error, _} ->
          [
            field_schema_id: "The last_value is not a valid value against the new field_schema.\
              You have to update the last_value in the same request as the field_schema_id."
          ]
      end
    end)
  end
end
