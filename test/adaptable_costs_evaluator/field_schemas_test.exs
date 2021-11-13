defmodule AdaptableCostsEvaluator.FieldSchemasTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.FieldSchemaFixture

  alias AdaptableCostsEvaluator.FieldSchemas

  describe "field_schemas" do
    alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

    setup do
      %{field_schema: field_schema_fixture()}
    end

    test "list_field_schemas/0 returns all field_schemas", %{field_schema: field_schema} do
      assert FieldSchemas.list_field_schemas() == [field_schema]
    end

    test "get_field_schema!/1 returns the field_schema with given id", %{
      field_schema: field_schema
    } do
      assert FieldSchemas.get_field_schema!(field_schema.id) == field_schema
    end

    test "create_field_schema/1 with valid data creates a field_schema" do
      attrs = %{@valid_field_schema_attrs | name: "custom name"}

      assert {:ok, %FieldSchema{} = field_schema} = FieldSchemas.create_field_schema(attrs)
      assert field_schema.definition == %{}
      assert field_schema.name == "custom name"
    end

    test "create_field_schema/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FieldSchemas.create_field_schema(@invalid_field_schema_attrs)
    end

    test "update_field_schema/2 with valid data updates the field_schema", %{
      field_schema: field_schema
    } do
      assert {:ok, %FieldSchema{} = field_schema} =
               FieldSchemas.update_field_schema(field_schema, @update_field_schema_attrs)

      assert field_schema.definition == %{}
      assert field_schema.name == "some updated name"
    end

    test "update_field_schema/2 with invalid data returns error changeset", %{
      field_schema: field_schema
    } do

      assert {:error, %Ecto.Changeset{}} =
               FieldSchemas.update_field_schema(field_schema, @invalid_field_schema_attrs)

      assert field_schema == FieldSchemas.get_field_schema!(field_schema.id)
    end

    test "delete_field_schema/1 deletes the field_schema", %{field_schema: field_schema} do
      assert {:ok, %FieldSchema{}} = FieldSchemas.delete_field_schema(field_schema)
      assert_raise Ecto.NoResultsError, fn -> FieldSchemas.get_field_schema!(field_schema.id) end
    end

    test "change_field_schema/1 returns a field_schema changeset", %{field_schema: field_schema} do
      assert %Ecto.Changeset{} = FieldSchemas.change_field_schema(field_schema)
    end
  end
end
