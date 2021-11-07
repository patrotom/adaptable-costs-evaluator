defmodule AdaptableCostsEvaluator.FormulasTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture, ComputationFixture, FormulaFixture}

  alias AdaptableCostsEvaluator.Formulas

  describe "formulas" do
    alias AdaptableCostsEvaluator.Formulas.Formula

    setup do
      user = user_fixture()
      computation = computation_fixture(user)
      formula = formula_fixture(%{computation_id: computation.id})

      %{formula: formula, computation: computation}
    end

    test "list_formulas/1 returns all desired formulas", %{
      formula: formula,
      computation: computation
    } do
      assert Formulas.list_formulas(computation) == [formula]
    end

    test "get_formula!/2 returns the formula with given id", %{
      formula: formula,
      computation: computation
    } do
      assert Formulas.get_formula!(formula.id, computation) == formula
    end

    test "create_formula/1 with valid data creates a formula", %{
      formula: _,
      computation: computation
    } do
      attrs =
        %{@valid_formula_attrs | label: "custom"}
        |> Map.put(:computation_id, computation.id)

      assert {:ok, %Formula{} = formula} = Formulas.create_formula(attrs)
      assert formula.definition == "some definition"
      assert formula.label == "custom"
      assert formula.name == "some name"
    end

    test "create_formula/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Formulas.create_formula(@invalid_formula_attrs)
    end

    test "update_formula/2 with valid data updates the formula", %{
      formula: formula,
      computation: _
    } do
      assert {:ok, %Formula{} = formula} = Formulas.update_formula(formula, @update_formula_attrs)
      assert formula.definition == "some updated definition"
      assert formula.label == "some updated label"
      assert formula.name == "some updated name"
    end

    test "update_formula/2 with invalid data returns error changeset", %{
      formula: formula,
      computation: computation
    } do
      assert {:error, %Ecto.Changeset{}} =
               Formulas.update_formula(formula, @invalid_formula_attrs)

      assert formula == Formulas.get_formula!(formula.id, computation)
    end

    test "delete_formula/1 deletes the formula", %{formula: formula, computation: computation} do
      assert {:ok, %Formula{}} = Formulas.delete_formula(formula)
      assert_raise Ecto.NoResultsError, fn -> Formulas.get_formula!(formula.id, computation) end
    end

    test "change_formula/1 returns a formula changeset", %{formula: formula, computation: _} do
      assert %Ecto.Changeset{} = Formulas.change_formula(formula)
    end
  end
end
