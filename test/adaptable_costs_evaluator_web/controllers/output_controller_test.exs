defmodule AdaptableCostsEvaluatorWeb.OutputControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.Outputs
  alias AdaptableCostsEvaluator.Outputs.Output

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

  def fixture(:output) do
    {:ok, output} = Outputs.create_output(@create_attrs)
    output
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all outputs", %{conn: conn} do
      conn = get(conn, Routes.output_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create output" do
    test "renders output when data is valid", %{conn: conn} do
      conn = post(conn, Routes.output_path(conn, :create), output: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.output_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label",
               "last_value" => %{},
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.output_path(conn, :create), output: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update output" do
    setup [:create_output]

    test "renders output when data is valid", %{conn: conn, output: %Output{id: id} = output} do
      conn = put(conn, Routes.output_path(conn, :update, output), output: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.output_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label",
               "last_value" => %{},
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, output: output} do
      conn = put(conn, Routes.output_path(conn, :update, output), output: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete output" do
    setup [:create_output]

    test "deletes chosen output", %{conn: conn, output: output} do
      conn = delete(conn, Routes.output_path(conn, :delete, output))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.output_path(conn, :show, output))
      end
    end
  end

  defp create_output(_) do
    output = fixture(:output)
    %{output: output}
  end
end
