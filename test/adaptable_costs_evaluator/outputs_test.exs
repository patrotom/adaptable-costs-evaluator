defmodule AdaptableCostsEvaluator.OutputsTest do
  use AdaptableCostsEvaluator.DataCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    ComputationFixture,
    FieldSchemaFixture,
    OutputFixture
  }

  alias AdaptableCostsEvaluator.Outputs

  describe "outputs" do
    alias AdaptableCostsEvaluator.Outputs.Output

    setup do
      user = user_fixture()
      computation = computation_fixture(user)
      field_schema = field_schema_fixture()
      output = output_fixture(%{computation_id: computation.id, field_schema_id: field_schema.id})

      %{output: output, computation: computation}
    end

    test "list_outputs/1 returns all desired outputs", %{output: output, computation: computation} do
      assert Outputs.list_outputs(computation) == [output]
    end

    test "get_output!/1 returns the output with given id", %{
      output: output,
      computation: computation
    } do
      assert Outputs.get_output!(output.id, computation) == output
    end

    test "create_output/1 with valid data creates a output", %{
      output: output,
      computation: computation
    } do
      attrs =
        %{@valid_output_attrs | label: "custom"}
        |> Map.put(:computation_id, computation.id)
        |> Map.put(:field_schema_id, output.field_schema_id)

      assert {:ok, %Output{} = output} = Outputs.create_output(attrs)
      assert output.label == attrs[:label]
      assert output.last_value == attrs[:last_value]
      assert output.name == attrs[:name]
    end

    test "create_output/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Outputs.create_output(@invalid_output_attrs)
    end

    test "update_output/2 with valid data updates the output", %{output: output, computation: _} do
      assert {:ok, %Output{} = output} = Outputs.update_output(output, @update_output_attrs)
      assert output.label == @update_output_attrs[:label]
      assert output.last_value == @update_output_attrs[:last_value]
      assert output.name == @update_output_attrs[:name]
    end

    test "update_output/2 with invalid data returns error changeset", %{
      output: output,
      computation: computation
    } do
      assert {:error, %Ecto.Changeset{}} = Outputs.update_output(output, @invalid_output_attrs)
      assert output == Outputs.get_output!(output.id, computation)
    end

    test "delete_output/1 deletes the output", %{output: output, computation: computation} do
      assert {:ok, %Output{}} = Outputs.delete_output(output)
      assert_raise Ecto.NoResultsError, fn -> Outputs.get_output!(output.id, computation) end
    end

    test "change_output/1 returns a output changeset", %{output: output, computation: _} do
      assert %Ecto.Changeset{} = Outputs.change_output(output)
    end
  end
end
