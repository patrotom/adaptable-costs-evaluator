defmodule AdaptableCostsEvaluator.EvaluatorsTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.EvaluatorFixture

  alias AdaptableCostsEvaluator.Evaluators

  describe "evaluators" do
    alias AdaptableCostsEvaluator.Evaluators.Evaluator

    setup do
      %{evaluator: evaluator_fixture()}
    end

    test "list_evaluators/0 returns all evaluators", %{evaluator: evaluator} do
      assert Evaluators.list_evaluators() == [evaluator]
    end

    test "get_evaluator!/1 returns the evaluator with given id", %{evaluator: evaluator} do
      assert Evaluators.get_evaluator!(evaluator.id) == evaluator
    end

    test "create_evaluator/1 with valid data creates a evaluator" do
      attrs = %{@valid_evaluator_attrs | name: "custom name"}

      assert {:ok, %Evaluator{} = evaluator} = Evaluators.create_evaluator(attrs)
      assert evaluator.description == attrs[:description]
      assert evaluator.module == attrs[:module]
      assert evaluator.name == attrs[:name]
    end

    test "create_evaluator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Evaluators.create_evaluator(@invalid_evaluator_attrs)
    end

    test "update_evaluator/2 with valid data updates the evaluator", %{evaluator: evaluator} do
      assert {:ok, %Evaluator{} = evaluator} =
               Evaluators.update_evaluator(evaluator, @update_evaluator_attrs)

      assert evaluator.description == @update_evaluator_attrs[:description]
      assert evaluator.module == @update_evaluator_attrs[:module]
      assert evaluator.name == @update_evaluator_attrs[:name]
    end

    test "update_evaluator/2 with invalid data returns error changeset", %{evaluator: evaluator} do
      assert {:error, %Ecto.Changeset{}} =
               Evaluators.update_evaluator(evaluator, @invalid_evaluator_attrs)

      assert evaluator == Evaluators.get_evaluator!(evaluator.id)
    end

    test "delete_evaluator/1 deletes the evaluator", %{evaluator: evaluator} do
      assert {:ok, %Evaluator{}} = Evaluators.delete_evaluator(evaluator)
      assert_raise Ecto.NoResultsError, fn -> Evaluators.get_evaluator!(evaluator.id) end
    end

    test "change_evaluator/1 returns a evaluator changeset", %{evaluator: evaluator} do
      assert %Ecto.Changeset{} = Evaluators.change_evaluator(evaluator)
    end
  end
end
