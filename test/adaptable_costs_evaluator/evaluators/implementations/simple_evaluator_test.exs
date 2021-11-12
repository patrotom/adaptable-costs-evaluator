defmodule AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluatorTest do
  use AdaptableCostsEvaluator.DataCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    ComputationFixture,
    FormulaFixture,
    InputFixture,
    FieldSchemaFixture
  }

  alias AdaptableCostsEvaluator.Formulas
  alias AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator

  describe "evaluate" do
    setup do
      computation = user_fixture() |> computation_fixture()

      attrs = %{computation_id: computation.id, definition: "10 + 5 * input1"}
      formula = formula_fixture(attrs)

      field_schema = field_schema_fixture(%{definition: %{"type" => "integer"}})

      attrs = %{
        computation_id: computation.id,
        last_value: 5,
        label: "input1",
        field_schema_id: field_schema.id
      }
      input_fixture(attrs)

      %{formula: formula}
    end

    test "evaluates the formula without any inputs in it", %{formula: formula} do
      {:ok, formula} = Formulas.update_formula(formula, %{definition: "10 + 10 * 20"})

      assert SimpleEvaluator.evaluate(formula) == {:ok, 210}
    end

    test "evaluates the formula with the input in it", %{formula: formula} do
      assert SimpleEvaluator.evaluate(formula) == {:ok, 35}
    end

    test "fails with an invalid formula definition", %{formula: formula} do
      {:ok, formula} = Formulas.update_formula(formula, %{definition: "+"})

      assert SimpleEvaluator.evaluate(formula) == {:error, "Invalid syntax"}
    end

    test "fails with an invalid input", %{formula: formula} do
      {:ok, formula} = Formulas.update_formula(formula, %{definition: "10 + random"})

      assert SimpleEvaluator.evaluate(formula) == {:error, "Invalid inputs: 'random'"}
    end
  end
end
