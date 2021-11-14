defmodule AdaptableCostsEvaluator.Fixtures.FormulaFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Formulas
  alias AdaptableCostsEvaluator.Formulas.Formula
  alias AdaptableCostsEvaluator.Outputs.Output

  using do
    quote do
      @valid_formula_attrs %{
        definition: "some definition",
        label: "some_label",
        name: "some name"
      }
      @update_formula_attrs %{
        definition: "some updated definition",
        label: "some_updated_label",
        name: "some updated name"
      }
      @invalid_formula_attrs %{definition: nil, label: nil, name: nil}

      def formula_fixture(attrs \\ %{}) do
        {:ok, formula} =
          attrs
          |> Enum.into(@valid_formula_attrs)
          |> Formulas.create_formula()

        formula
      end

      def formula_response(%Formula{} = formula) do
        %{
          "id" => formula.id,
          "name" => formula.name,
          "label" => formula.label,
          "definition" => formula.definition,
          "computation_id" => formula.computation_id,
          "evaluator_id" => formula.evaluator_id
        }
      end

      def evaluate_formula_response(%Formula{} = formula, result) do
        outputs = AdaptableCostsEvaluator.Repo.preload(formula, :outputs).outputs
        affected_outputs = Enum.map(outputs, fn o -> _output_response(o) end)

        %{
          "result" => result,
          "affected_outputs" => %{"data" => affected_outputs}
        }
      end

      defp _output_response(%Output{} = output) do
        %{
          "id" => output.id,
          "name" => output.name,
          "label" => output.label,
          "last_value" => output.last_value,
          "field_schema_id" => output.field_schema_id,
          "formula_id" => output.formula_id
        }
      end
    end
  end
end
