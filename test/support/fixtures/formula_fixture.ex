defmodule AdaptableCostsEvaluator.Fixtures.FormulaFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Formulas
  alias AdaptableCostsEvaluator.Formulas.Formula

  using do
    quote do
      @valid_attrs %{definition: "some definition", label: "some label", name: "some name"}
      @update_attrs %{definition: "some updated definition", label: "some updated label", name: "some updated name"}
      @invalid_attrs %{definition: nil, label: nil, name: nil}

      def formula_fixture(attrs \\ %{}) do
        {:ok, formula} =
          attrs
          |> Enum.into(@valid_attrs)
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
        }
      end
    end
  end
end
