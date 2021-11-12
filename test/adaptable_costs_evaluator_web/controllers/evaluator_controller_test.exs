defmodule AdaptableCostsEvaluatorWeb.EvaluatorControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.Evaluators
  alias AdaptableCostsEvaluator.Evaluators.Evaluator

  @create_attrs %{
    description: "some description",
    module: "some module",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    module: "some updated module",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, module: nil, name: nil}

  def fixture(:evaluator) do
    {:ok, evaluator} = Evaluators.create_evaluator(@create_attrs)
    evaluator
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all evaluators", %{conn: conn} do
      conn = get(conn, Routes.evaluator_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create evaluator" do
    test "renders evaluator when data is valid", %{conn: conn} do
      conn = post(conn, Routes.evaluator_path(conn, :create), evaluator: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.evaluator_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "module" => "some module",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.evaluator_path(conn, :create), evaluator: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update evaluator" do
    setup [:create_evaluator]

    test "renders evaluator when data is valid", %{conn: conn, evaluator: %Evaluator{id: id} = evaluator} do
      conn = put(conn, Routes.evaluator_path(conn, :update, evaluator), evaluator: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.evaluator_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "module" => "some updated module",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, evaluator: evaluator} do
      conn = put(conn, Routes.evaluator_path(conn, :update, evaluator), evaluator: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete evaluator" do
    setup [:create_evaluator]

    test "deletes chosen evaluator", %{conn: conn, evaluator: evaluator} do
      conn = delete(conn, Routes.evaluator_path(conn, :delete, evaluator))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.evaluator_path(conn, :show, evaluator))
      end
    end
  end

  defp create_evaluator(_) do
    evaluator = fixture(:evaluator)
    %{evaluator: evaluator}
  end
end
