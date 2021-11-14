defmodule AdaptableCostsEvaluator.InputsTest do
  use AdaptableCostsEvaluator.DataCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    ComputationFixture,
    InputFixture,
    FieldSchemaFixture
  }

  alias AdaptableCostsEvaluator.Inputs

  describe "inputs" do
    alias AdaptableCostsEvaluator.Inputs.Input

    setup do
      user = user_fixture()
      computation = computation_fixture(user)
      field_schema = field_schema_fixture()
      input = input_fixture(%{computation_id: computation.id, field_schema_id: field_schema.id})

      %{input: input, computation: computation}
    end

    test "list_inputs/1 returns all desired inputs", %{input: input, computation: computation} do
      assert Inputs.list_inputs(computation) == [input]
    end

    test "get_input!/2 returns the input with given id", %{input: input, computation: computation} do
      assert Inputs.get_input!(input.id, computation) == input
    end

    test "create_input/1 with valid data creates a input", %{
      input: input,
      computation: computation
    } do
      attrs =
        %{@valid_input_attrs | label: "custom"}
        |> Map.put(:computation_id, computation.id)
        |> Map.put(:field_schema_id, input.field_schema_id)

      assert {:ok, %Input{} = input} = Inputs.create_input(attrs)
      assert input.label == attrs[:label]
      assert input.last_value == attrs[:last_value]
      assert input.name == attrs[:name]
    end

    test "create_input/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inputs.create_input(@invalid_input_attrs)
    end

    test "update_input/2 with valid data updates the input", %{input: input, computation: _} do
      assert {:ok, %Input{} = input} = Inputs.update_input(input, @update_input_attrs)
      assert input.label == @update_input_attrs[:label]
      assert input.last_value == @update_input_attrs[:last_value]
      assert input.name == @update_input_attrs[:name]
    end

    test "update_input/2 with invalid data returns error changeset", %{
      input: input,
      computation: computation
    } do
      assert {:error, %Ecto.Changeset{}} = Inputs.update_input(input, @invalid_input_attrs)
      assert input == Inputs.get_input!(input.id, computation)
    end

    test "delete_input/1 deletes the input", %{input: input, computation: computation} do
      assert {:ok, %Input{}} = Inputs.delete_input(input)
      assert_raise Ecto.NoResultsError, fn -> Inputs.get_input!(input.id, computation) end
    end

    test "change_input/1 returns a input changeset", %{input: input, computation: _} do
      assert %Ecto.Changeset{} = Inputs.change_input(input)
    end
  end
end
