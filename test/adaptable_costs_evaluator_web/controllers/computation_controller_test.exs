defmodule AdaptableCostsEvaluatorWeb.ComputationControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.Computations
  alias AdaptableCostsEvaluator.Computations.Computation

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:computation) do
    {:ok, computation} = Computations.create_computation(@create_attrs)
    computation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all computations", %{conn: conn} do
      conn = get(conn, Routes.computation_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create computation" do
    test "renders computation when data is valid", %{conn: conn} do
      conn = post(conn, Routes.computation_path(conn, :create), computation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.computation_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.computation_path(conn, :create), computation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update computation" do
    setup [:create_computation]

    test "renders computation when data is valid", %{conn: conn, computation: %Computation{id: id} = computation} do
      conn = put(conn, Routes.computation_path(conn, :update, computation), computation: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.computation_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, computation: computation} do
      conn = put(conn, Routes.computation_path(conn, :update, computation), computation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete computation" do
    setup [:create_computation]

    test "deletes chosen computation", %{conn: conn, computation: computation} do
      conn = delete(conn, Routes.computation_path(conn, :delete, computation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.computation_path(conn, :show, computation))
      end
    end
  end

  defp create_computation(_) do
    computation = fixture(:computation)
    %{computation: computation}
  end
end
