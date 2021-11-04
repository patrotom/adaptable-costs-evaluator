defmodule AdaptableCostsEvaluatorWeb.FieldSchemaControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.FieldSchemas
  alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

  @create_attrs %{
    definition: %{},
    name: "some name"
  }
  @update_attrs %{
    definition: %{},
    name: "some updated name"
  }
  @invalid_attrs %{definition: nil, name: nil}

  def fixture(:field_schema) do
    {:ok, field_schema} = FieldSchemas.create_field_schema(@create_attrs)
    field_schema
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all field_schemas", %{conn: conn} do
      conn = get(conn, Routes.field_schema_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create field_schema" do
    test "renders field_schema when data is valid", %{conn: conn} do
      conn = post(conn, Routes.field_schema_path(conn, :create), field_schema: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.field_schema_path(conn, :show, id))

      assert %{
               "id" => id,
               "definition" => %{},
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.field_schema_path(conn, :create), field_schema: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update field_schema" do
    setup [:create_field_schema]

    test "renders field_schema when data is valid", %{conn: conn, field_schema: %FieldSchema{id: id} = field_schema} do
      conn = put(conn, Routes.field_schema_path(conn, :update, field_schema), field_schema: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.field_schema_path(conn, :show, id))

      assert %{
               "id" => id,
               "definition" => %{},
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, field_schema: field_schema} do
      conn = put(conn, Routes.field_schema_path(conn, :update, field_schema), field_schema: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete field_schema" do
    setup [:create_field_schema]

    test "deletes chosen field_schema", %{conn: conn, field_schema: field_schema} do
      conn = delete(conn, Routes.field_schema_path(conn, :delete, field_schema))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.field_schema_path(conn, :show, field_schema))
      end
    end
  end

  defp create_field_schema(_) do
    field_schema = fixture(:field_schema)
    %{field_schema: field_schema}
  end
end
