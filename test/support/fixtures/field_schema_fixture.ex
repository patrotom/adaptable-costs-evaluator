defmodule AdaptableCostsEvaluator.Fixtures.FieldSchemaFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.FieldSchemas
  alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

  using do
    quote do
      @valid_attrs %{definition: %{}, name: "some name"}
      @update_attrs %{definition: %{}, name: "some updated name"}
      @invalid_attrs %{definition: nil, name: nil}

      def field_schema_fixture(attrs \\ %{}) do
        {:ok, field_schema} =
          attrs
          |> Enum.into(@valid_attrs)
          |> FieldSchemas.create_field_schema()

        field_schema
      end

      def field_schema_response(%FieldSchema{} = field_schema) do
        %{
          "id" => field_schema.id,
          "name" => field_schema.name,
          "definition" => field_schema.definition,
        }
      end
    end
  end
end
