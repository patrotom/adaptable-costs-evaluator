defmodule AdaptableCostsEvaluatorWeb.EvaluatorControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture, EvaluatorFixture}

  alias AdaptableCostsEvaluator.Evaluators

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    evaluator = evaluator_fixture()
    {:ok, conn: conn} = setup_authd_conn(user, conn)

    %{conn: conn, evaluator: evaluator}
  end

  describe "index" do
    test "lists all evaluators", %{conn: conn, evaluator: evaluator} do
      conn = get(conn, Routes.evaluator_path(conn, :index))
      assert json_response(conn, 200)["data"] == [evaluator_response(evaluator)]
    end
  end

  describe "create evaluator" do
    test "renders evaluator when data is valid", %{conn: conn, evaluator: _} do
      attrs = %{@valid_evaluator_attrs | name: "custom"}

      conn = post(conn, Routes.evaluator_path(conn, :create), evaluator: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.evaluator_path(conn, :show, id))
      evaluator = Evaluators.get_evaluator!(id)

      assert json_response(conn, 200)["data"] == evaluator_response(evaluator)
    end

    test "renders errors when data is invalid", %{conn: conn, evaluator: _} do
      conn = post(conn, Routes.evaluator_path(conn, :create), evaluator: @invalid_evaluator_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update evaluator" do
    test "renders evaluator when data is valid", %{conn: conn, evaluator: evaluator} do
      conn =
        put(conn, Routes.evaluator_path(conn, :update, evaluator),
          evaluator: @update_evaluator_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.evaluator_path(conn, :show, id))
      evaluator = Evaluators.get_evaluator!(id)

      assert json_response(conn, 200)["data"] == evaluator_response(evaluator)
    end

    test "renders errors when data is invalid", %{conn: conn, evaluator: evaluator} do
      conn =
        put(conn, Routes.evaluator_path(conn, :update, evaluator),
          evaluator: @invalid_evaluator_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete evaluator" do
    test "deletes chosen evaluator", %{conn: conn, evaluator: evaluator} do
      conn = delete(conn, Routes.evaluator_path(conn, :delete, evaluator))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.evaluator_path(conn, :show, evaluator))
      end
    end
  end
end
