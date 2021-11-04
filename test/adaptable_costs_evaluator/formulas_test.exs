defmodule AdaptableCostsEvaluator.FormulasTest do
  use AdaptableCostsEvaluator.DataCase

  alias AdaptableCostsEvaluator.Formulas

  describe "formulas" do
    alias AdaptableCostsEvaluator.Formulas.Formula

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

    test "list_formulas/0 returns all formulas" do
      formula = formula_fixture()
      assert Formulas.list_formulas() == [formula]
    end

    test "get_formula!/1 returns the formula with given id" do
      formula = formula_fixture()
      assert Formulas.get_formula!(formula.id) == formula
    end

    test "create_formula/1 with valid data creates a formula" do
      assert {:ok, %Formula{} = formula} = Formulas.create_formula(@valid_attrs)
      assert formula.definition == "some definition"
      assert formula.label == "some label"
      assert formula.name == "some name"
    end

    test "create_formula/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Formulas.create_formula(@invalid_attrs)
    end

    test "update_formula/2 with valid data updates the formula" do
      formula = formula_fixture()
      assert {:ok, %Formula{} = formula} = Formulas.update_formula(formula, @update_attrs)
      assert formula.definition == "some updated definition"
      assert formula.label == "some updated label"
      assert formula.name == "some updated name"
    end

    test "update_formula/2 with invalid data returns error changeset" do
      formula = formula_fixture()
      assert {:error, %Ecto.Changeset{}} = Formulas.update_formula(formula, @invalid_attrs)
      assert formula == Formulas.get_formula!(formula.id)
    end

    test "delete_formula/1 deletes the formula" do
      formula = formula_fixture()
      assert {:ok, %Formula{}} = Formulas.delete_formula(formula)
      assert_raise Ecto.NoResultsError, fn -> Formulas.get_formula!(formula.id) end
    end

    test "change_formula/1 returns a formula changeset" do
      formula = formula_fixture()
      assert %Ecto.Changeset{} = Formulas.change_formula(formula)
    end
  end
end
