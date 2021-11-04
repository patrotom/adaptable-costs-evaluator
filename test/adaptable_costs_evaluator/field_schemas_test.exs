defmodule AdaptableCostsEvaluator.FieldSchemasTest do
  use AdaptableCostsEvaluator.DataCase

  alias AdaptableCostsEvaluator.FieldSchemas

  describe "field_schemas" do
    alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

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

    test "list_field_schemas/0 returns all field_schemas" do
      field_schema = field_schema_fixture()
      assert FieldSchemas.list_field_schemas() == [field_schema]
    end

    test "get_field_schema!/1 returns the field_schema with given id" do
      field_schema = field_schema_fixture()
      assert FieldSchemas.get_field_schema!(field_schema.id) == field_schema
    end

    test "create_field_schema/1 with valid data creates a field_schema" do
      assert {:ok, %FieldSchema{} = field_schema} = FieldSchemas.create_field_schema(@valid_attrs)
      assert field_schema.definition == %{}
      assert field_schema.name == "some name"
    end

    test "create_field_schema/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FieldSchemas.create_field_schema(@invalid_attrs)
    end

    test "update_field_schema/2 with valid data updates the field_schema" do
      field_schema = field_schema_fixture()
      assert {:ok, %FieldSchema{} = field_schema} = FieldSchemas.update_field_schema(field_schema, @update_attrs)
      assert field_schema.definition == %{}
      assert field_schema.name == "some updated name"
    end

    test "update_field_schema/2 with invalid data returns error changeset" do
      field_schema = field_schema_fixture()
      assert {:error, %Ecto.Changeset{}} = FieldSchemas.update_field_schema(field_schema, @invalid_attrs)
      assert field_schema == FieldSchemas.get_field_schema!(field_schema.id)
    end

    test "delete_field_schema/1 deletes the field_schema" do
      field_schema = field_schema_fixture()
      assert {:ok, %FieldSchema{}} = FieldSchemas.delete_field_schema(field_schema)
      assert_raise Ecto.NoResultsError, fn -> FieldSchemas.get_field_schema!(field_schema.id) end
    end

    test "change_field_schema/1 returns a field_schema changeset" do
      field_schema = field_schema_fixture()
      assert %Ecto.Changeset{} = FieldSchemas.change_field_schema(field_schema)
    end
  end
end
