defmodule AdaptableCostsEvaluator.EvaluatorsTest do
  use AdaptableCostsEvaluator.DataCase

  alias AdaptableCostsEvaluator.Evaluators

  describe "evaluators" do
    alias AdaptableCostsEvaluator.Evaluators.Evaluator

    @valid_attrs %{description: "some description", module: "some module", name: "some name"}
    @update_attrs %{description: "some updated description", module: "some updated module", name: "some updated name"}
    @invalid_attrs %{description: nil, module: nil, name: nil}

    def evaluator_fixture(attrs \\ %{}) do
      {:ok, evaluator} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Evaluators.create_evaluator()

      evaluator
    end

    test "list_evaluators/0 returns all evaluators" do
      evaluator = evaluator_fixture()
      assert Evaluators.list_evaluators() == [evaluator]
    end

    test "get_evaluator!/1 returns the evaluator with given id" do
      evaluator = evaluator_fixture()
      assert Evaluators.get_evaluator!(evaluator.id) == evaluator
    end

    test "create_evaluator/1 with valid data creates a evaluator" do
      assert {:ok, %Evaluator{} = evaluator} = Evaluators.create_evaluator(@valid_attrs)
      assert evaluator.description == "some description"
      assert evaluator.module == "some module"
      assert evaluator.name == "some name"
    end

    test "create_evaluator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Evaluators.create_evaluator(@invalid_attrs)
    end

    test "update_evaluator/2 with valid data updates the evaluator" do
      evaluator = evaluator_fixture()
      assert {:ok, %Evaluator{} = evaluator} = Evaluators.update_evaluator(evaluator, @update_attrs)
      assert evaluator.description == "some updated description"
      assert evaluator.module == "some updated module"
      assert evaluator.name == "some updated name"
    end

    test "update_evaluator/2 with invalid data returns error changeset" do
      evaluator = evaluator_fixture()
      assert {:error, %Ecto.Changeset{}} = Evaluators.update_evaluator(evaluator, @invalid_attrs)
      assert evaluator == Evaluators.get_evaluator!(evaluator.id)
    end

    test "delete_evaluator/1 deletes the evaluator" do
      evaluator = evaluator_fixture()
      assert {:ok, %Evaluator{}} = Evaluators.delete_evaluator(evaluator)
      assert_raise Ecto.NoResultsError, fn -> Evaluators.get_evaluator!(evaluator.id) end
    end

    test "change_evaluator/1 returns a evaluator changeset" do
      evaluator = evaluator_fixture()
      assert %Ecto.Changeset{} = Evaluators.change_evaluator(evaluator)
    end
  end
end
