defmodule AdaptableCostsEvaluatorWeb.OutputControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    ComputationFixture,
    OutputFixture,
    FieldSchemaFixture
  }

  alias AdaptableCostsEvaluator.Outputs

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    computation = computation_fixture(user)
    field_schema = field_schema_fixture()
    output = output_fixture(%{computation_id: computation.id, field_schema_id: field_schema.id})
    {:ok, conn: conn} = setup_authd_conn(user, conn)

    %{conn: conn, computation: computation, output: output}
  end

  describe "index" do
    test "lists all outputs", %{conn: conn, computation: computation, output: output} do
      conn = get(conn, Routes.computation_output_path(conn, :index, computation.id))
      assert json_response(conn, 200)["data"] == [output_response(output)]
    end
  end

  describe "create output" do
    test "renders output when data is valid", %{
      conn: conn,
      computation: computation,
      output: output
    } do
      attrs =
        %{@valid_output_attrs | label: "custom"}
        |> Map.put(:computation_id, computation.id)
        |> Map.put(:field_schema_id, output.field_schema_id)

      conn =
        post(conn, Routes.computation_output_path(conn, :create, computation.id), output: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.computation_output_path(conn, :show, computation.id, id))
      output = Outputs.get_output!(id, computation)

      assert json_response(conn, 200)["data"] == output_response(output)
    end

    test "renders errors when data is invalid", %{conn: conn, computation: computation, output: _} do
      conn =
        post(conn, Routes.computation_output_path(conn, :create, computation.id),
          output: @invalid_computation_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update output" do
    test "renders output when data is valid", %{
      conn: conn,
      computation: computation,
      output: output
    } do
      conn =
        put(conn, Routes.computation_output_path(conn, :update, computation.id, output.id),
          output: @update_output_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.computation_output_path(conn, :show, computation.id, id))
      output = Outputs.get_output!(id, computation)

      assert json_response(conn, 200)["data"] == output_response(output)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      computation: computation,
      output: output
    } do
      conn =
        put(conn, Routes.computation_output_path(conn, :update, computation.id, output.id),
          output: @invalid_output_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete output" do
    test "deletes chosen output", %{conn: conn, computation: computation, output: output} do
      conn =
        delete(conn, Routes.computation_output_path(conn, :delete, computation.id, output.id))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.computation_output_path(conn, :show, computation.id, output.id))
      end
    end
  end
end
