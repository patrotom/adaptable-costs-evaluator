defmodule AdaptableCostsEvaluatorWeb.FormulaControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.Formulas
  alias AdaptableCostsEvaluator.Formulas.Formula

  @create_attrs %{
    definition: "some definition",
    label: "some label",
    name: "some name"
  }
  @update_attrs %{
    definition: "some updated definition",
    label: "some updated label",
    name: "some updated name"
  }
  @invalid_attrs %{definition: nil, label: nil, name: nil}

  def fixture(:formula) do
    {:ok, formula} = Formulas.create_formula(@create_attrs)
    formula
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all formulas", %{conn: conn} do
      conn = get(conn, Routes.formula_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create formula" do
    test "renders formula when data is valid", %{conn: conn} do
      conn = post(conn, Routes.formula_path(conn, :create), formula: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.formula_path(conn, :show, id))

      assert %{
               "id" => id,
               "definition" => "some definition",
               "label" => "some label",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.formula_path(conn, :create), formula: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update formula" do
    setup [:create_formula]

    test "renders formula when data is valid", %{conn: conn, formula: %Formula{id: id} = formula} do
      conn = put(conn, Routes.formula_path(conn, :update, formula), formula: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.formula_path(conn, :show, id))

      assert %{
               "id" => id,
               "definition" => "some updated definition",
               "label" => "some updated label",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, formula: formula} do
      conn = put(conn, Routes.formula_path(conn, :update, formula), formula: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete formula" do
    setup [:create_formula]

    test "deletes chosen formula", %{conn: conn, formula: formula} do
      conn = delete(conn, Routes.formula_path(conn, :delete, formula))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.formula_path(conn, :show, formula))
      end
    end
  end

  defp create_formula(_) do
    formula = fixture(:formula)
    %{formula: formula}
  end
end
