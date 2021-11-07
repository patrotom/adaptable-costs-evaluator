defmodule AdaptableCostsEvaluatorWeb.InputControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    ComputationFixture,
    InputFixture,
    FieldSchemaFixture
  }

  alias AdaptableCostsEvaluator.Inputs

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    computation = computation_fixture(user)
    field_schema = field_schema_fixture()
    input = input_fixture(%{computation_id: computation.id, field_schema_id: field_schema.id})
    {:ok, conn: conn} = setup_authd_conn(user, conn)

    %{conn: conn, computation: computation, input: input}
  end

  describe "index" do
    test "lists all inputs", %{conn: conn, computation: computation, input: input} do
      conn = get(conn, Routes.computation_input_path(conn, :index, computation.id))
      assert json_response(conn, 200)["data"] == [input_response(input)]
    end
  end

  describe "create input" do
    test "renders input when data is valid", %{conn: conn, computation: computation, input: input} do
      attrs =
        %{@valid_input_attrs | label: "custom"}
        |> Map.put(:computation_id, computation.id)
        |> Map.put(:field_schema_id, input.field_schema_id)

      conn =
        post(conn, Routes.computation_input_path(conn, :create, computation.id), input: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.computation_input_path(conn, :show, computation.id, id))
      input = Inputs.get_input!(id, computation)

      assert json_response(conn, 200)["data"] == input_response(input)
    end

    test "renders errors when data is invalid", %{conn: conn, computation: computation, input: _} do
      conn =
        post(conn, Routes.computation_input_path(conn, :create, computation.id),
          input: @invalid_computation_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update input" do
    test "renders input when data is valid", %{conn: conn, computation: computation, input: input} do
      conn =
        put(conn, Routes.computation_input_path(conn, :update, computation.id, input.id),
          input: @update_input_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.computation_input_path(conn, :show, computation.id, id))
      input = Inputs.get_input!(id, computation)

      assert json_response(conn, 200)["data"] == input_response(input)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      computation: computation,
      input: input
    } do
      conn =
        put(conn, Routes.computation_input_path(conn, :update, computation.id, input.id),
          input: @invalid_input_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete input" do
    test "deletes chosen input", %{conn: conn, computation: computation, input: input} do
      conn = delete(conn, Routes.computation_input_path(conn, :delete, computation.id, input.id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.computation_input_path(conn, :show, computation.id, input.id))
      end
    end
  end
end
