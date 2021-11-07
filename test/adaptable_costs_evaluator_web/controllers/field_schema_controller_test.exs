defmodule AdaptableCostsEvaluatorWeb.FieldSchemaControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture, FieldSchemaFixture}

  alias AdaptableCostsEvaluator.FieldSchemas

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    field_schema = field_schema_fixture()
    {:ok, conn: conn} = setup_authd_conn(user, conn)

    %{conn: conn, field_schema: field_schema}
  end

  describe "index" do
    test "lists all field_schemas", %{conn: conn, field_schema: field_schema} do
      conn = get(conn, Routes.field_schema_path(conn, :index))
      assert json_response(conn, 200)["data"] == [field_schema_response(field_schema)]
    end
  end

  describe "create field_schema" do
    test "renders field_schema when data is valid", %{conn: conn, field_schema: _} do
      attrs = %{@valid_field_schema_attrs | name: "custom"}

      conn = post(conn, Routes.field_schema_path(conn, :create), field_schema: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.field_schema_path(conn, :show, id))
      field_schema = FieldSchemas.get_field_schema!(id)

      assert json_response(conn, 200)["data"] == field_schema_response(field_schema)
    end

    test "renders errors when data is invalid", %{conn: conn, field_schema: _} do
      conn =
        post(conn, Routes.field_schema_path(conn, :create),
          field_schema: @invalid_field_schema_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update field_schema" do
    test "renders field_schema when data is valid", %{conn: conn, field_schema: field_schema} do
      conn =
        put(conn, Routes.field_schema_path(conn, :update, field_schema),
          field_schema: @update_field_schema_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.field_schema_path(conn, :show, id))
      field_schema = FieldSchemas.get_field_schema!(id)

      assert json_response(conn, 200)["data"] == field_schema_response(field_schema)
    end

    test "renders errors when data is invalid", %{conn: conn, field_schema: field_schema} do
      conn =
        put(conn, Routes.field_schema_path(conn, :update, field_schema),
          field_schema: @invalid_field_schema_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete field_schema" do
    test "deletes chosen field_schema", %{conn: conn, field_schema: field_schema} do
      conn = delete(conn, Routes.field_schema_path(conn, :delete, field_schema))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.field_schema_path(conn, :show, field_schema))
      end
    end
  end
end
