defmodule AdaptableCostsEvaluatorWeb.InputControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.Inputs
  alias AdaptableCostsEvaluator.Inputs.Input

  @create_attrs %{
    label: "some label",
    last_value: %{},
    name: "some name"
  }
  @update_attrs %{
    label: "some updated label",
    last_value: %{},
    name: "some updated name"
  }
  @invalid_attrs %{label: nil, last_value: nil, name: nil}

  def fixture(:input) do
    {:ok, input} = Inputs.create_input(@create_attrs)
    input
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all inputs", %{conn: conn} do
      conn = get(conn, Routes.input_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create input" do
    test "renders input when data is valid", %{conn: conn} do
      conn = post(conn, Routes.input_path(conn, :create), input: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.input_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label",
               "last_value" => %{},
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.input_path(conn, :create), input: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update input" do
    setup [:create_input]

    test "renders input when data is valid", %{conn: conn, input: %Input{id: id} = input} do
      conn = put(conn, Routes.input_path(conn, :update, input), input: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.input_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label",
               "last_value" => %{},
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, input: input} do
      conn = put(conn, Routes.input_path(conn, :update, input), input: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete input" do
    setup [:create_input]

    test "deletes chosen input", %{conn: conn, input: input} do
      conn = delete(conn, Routes.input_path(conn, :delete, input))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.input_path(conn, :show, input))
      end
    end
  end

  defp create_input(_) do
    input = fixture(:input)
    %{input: input}
  end
end
