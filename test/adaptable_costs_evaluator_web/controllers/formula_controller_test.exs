defmodule AdaptableCostsEvaluatorWeb.FormulaControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    ComputationFixture,
    FormulaFixture,
    EvaluatorFixture,
    FieldSchemaFixture,
    OutputFixture,
    InputFixture
  }

  alias AdaptableCostsEvaluator.Formulas

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    computation = computation_fixture(user)
    formula = formula_fixture(%{computation_id: computation.id})
    {:ok, conn: conn} = setup_authd_conn(user, conn)

    %{conn: conn, computation: computation, formula: formula}
  end

  describe "index" do
    test "lists all formulas in computation", %{
      conn: conn,
      computation: computation,
      formula: formula
    } do
      conn = get(conn, Routes.computation_formula_path(conn, :index, computation.id))
      assert json_response(conn, 200)["data"] == [formula_response(formula)]
    end
  end

  describe "create formula" do
    test "renders formula when data is valid", %{conn: conn, computation: computation, formula: _} do
      attrs =
        %{@valid_formula_attrs | label: "custom"}
        |> Map.put(:computation_id, computation.id)

      conn =
        post(conn, Routes.computation_formula_path(conn, :create, computation.id), formula: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.computation_formula_path(conn, :show, computation.id, id))
      formula = Formulas.get_formula!(id, computation)

      assert json_response(conn, 200)["data"] == formula_response(formula)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      computation: computation,
      formula: _
    } do
      conn =
        post(conn, Routes.computation_formula_path(conn, :create, computation.id),
          formula: @invalid_computation_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update formula" do
    test "renders formula when data is valid", %{
      conn: conn,
      computation: computation,
      formula: formula
    } do
      conn =
        put(conn, Routes.computation_formula_path(conn, :update, computation.id, formula.id),
          formula: @update_computation_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.computation_formula_path(conn, :show, computation.id, id))
      formula = Formulas.get_formula!(id, computation)

      assert json_response(conn, 200)["data"] == formula_response(formula)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      computation: computation,
      formula: formula
    } do
      conn =
        put(conn, Routes.computation_formula_path(conn, :update, computation.id, formula.id),
          formula: @invalid_computation_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete formula" do
    test "deletes chosen formula", %{conn: conn, computation: computation, formula: formula} do
      conn =
        delete(conn, Routes.computation_formula_path(conn, :delete, computation.id, formula.id))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.computation_formula_path(conn, :show, computation.id, formula.id))
      end
    end
  end

  describe "evaluate formula" do
    setup %{conn: _, computation: computation, formula: formula} do
      evaluator = evaluator_fixture()
      attrs = %{definition: "10 + 5 * input1", evaluator_id: evaluator.id}
      {:ok, formula} = Formulas.update_formula(formula, attrs)

      field_schema = field_schema_fixture(%{definition: %{"type" => "integer"}})

      attrs = %{
        computation_id: computation.id,
        last_value: 5,
        label: "input1",
        field_schema_id: field_schema.id
      }

      input_fixture(attrs)

      attrs = %{
        computation_id: computation.id,
        label: "output1",
        field_schema_id: field_schema.id,
        formula_id: formula.id
      }

      output_fixture(attrs)

      %{formula: formula}
    end

    test "evaluates chosen formula with the valid data", context do
      conn =
        post(
          context[:conn],
          Routes.computation_formula_path(
            context[:conn],
            :evaluate,
            context[:computation].id,
            context[:formula].id
          )
        )

      assert json_response(conn, 200)["data"] == evaluate_formula_response(context[:formula], 35)
    end
  end
end
