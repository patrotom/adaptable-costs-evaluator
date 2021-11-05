defmodule AdaptableCostsEvaluator.InputsTest do
  use AdaptableCostsEvaluator.DataCase

  alias AdaptableCostsEvaluator.Inputs

  describe "inputs" do
    alias AdaptableCostsEvaluator.Inputs.Input

    @valid_attrs %{label: "some label", last_value: %{}, name: "some name"}
    @update_attrs %{label: "some updated label", last_value: %{}, name: "some updated name"}
    @invalid_attrs %{label: nil, last_value: nil, name: nil}

    def input_fixture(attrs \\ %{}) do
      {:ok, input} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Inputs.create_input()

      input
    end

    test "list_inputs/0 returns all inputs" do
      input = input_fixture()
      assert Inputs.list_inputs() == [input]
    end

    test "get_input!/1 returns the input with given id" do
      input = input_fixture()
      assert Inputs.get_input!(input.id) == input
    end

    test "create_input/1 with valid data creates a input" do
      assert {:ok, %Input{} = input} = Inputs.create_input(@valid_attrs)
      assert input.label == "some label"
      assert input.last_value == %{}
      assert input.name == "some name"
    end

    test "create_input/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inputs.create_input(@invalid_attrs)
    end

    test "update_input/2 with valid data updates the input" do
      input = input_fixture()
      assert {:ok, %Input{} = input} = Inputs.update_input(input, @update_attrs)
      assert input.label == "some updated label"
      assert input.last_value == %{}
      assert input.name == "some updated name"
    end

    test "update_input/2 with invalid data returns error changeset" do
      input = input_fixture()
      assert {:error, %Ecto.Changeset{}} = Inputs.update_input(input, @invalid_attrs)
      assert input == Inputs.get_input!(input.id)
    end

    test "delete_input/1 deletes the input" do
      input = input_fixture()
      assert {:ok, %Input{}} = Inputs.delete_input(input)
      assert_raise Ecto.NoResultsError, fn -> Inputs.get_input!(input.id) end
    end

    test "change_input/1 returns a input changeset" do
      input = input_fixture()
      assert %Ecto.Changeset{} = Inputs.change_input(input)
    end
  end
end
