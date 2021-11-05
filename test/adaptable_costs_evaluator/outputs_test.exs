defmodule AdaptableCostsEvaluator.OutputsTest do
  use AdaptableCostsEvaluator.DataCase

  alias AdaptableCostsEvaluator.Outputs

  describe "outputs" do
    alias AdaptableCostsEvaluator.Outputs.Output

    @valid_attrs %{label: "some label", last_value: %{}, name: "some name"}
    @update_attrs %{label: "some updated label", last_value: %{}, name: "some updated name"}
    @invalid_attrs %{label: nil, last_value: nil, name: nil}

    def output_fixture(attrs \\ %{}) do
      {:ok, output} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Outputs.create_output()

      output
    end

    test "list_outputs/0 returns all outputs" do
      output = output_fixture()
      assert Outputs.list_outputs() == [output]
    end

    test "get_output!/1 returns the output with given id" do
      output = output_fixture()
      assert Outputs.get_output!(output.id) == output
    end

    test "create_output/1 with valid data creates a output" do
      assert {:ok, %Output{} = output} = Outputs.create_output(@valid_attrs)
      assert output.label == "some label"
      assert output.last_value == %{}
      assert output.name == "some name"
    end

    test "create_output/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Outputs.create_output(@invalid_attrs)
    end

    test "update_output/2 with valid data updates the output" do
      output = output_fixture()
      assert {:ok, %Output{} = output} = Outputs.update_output(output, @update_attrs)
      assert output.label == "some updated label"
      assert output.last_value == %{}
      assert output.name == "some updated name"
    end

    test "update_output/2 with invalid data returns error changeset" do
      output = output_fixture()
      assert {:error, %Ecto.Changeset{}} = Outputs.update_output(output, @invalid_attrs)
      assert output == Outputs.get_output!(output.id)
    end

    test "delete_output/1 deletes the output" do
      output = output_fixture()
      assert {:ok, %Output{}} = Outputs.delete_output(output)
      assert_raise Ecto.NoResultsError, fn -> Outputs.get_output!(output.id) end
    end

    test "change_output/1 returns a output changeset" do
      output = output_fixture()
      assert %Ecto.Changeset{} = Outputs.change_output(output)
    end
  end
end
