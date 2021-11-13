defmodule AdaptableCostsEvaluator.Validators.FieldValueValidatorTest do
  use AdaptableCostsEvaluator.DataCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    ComputationFixture,
    InputFixture,
    FieldSchemaFixture
  }

  alias AdaptableCostsEvaluator.Inputs
  alias AdaptableCostsEvaluator.Validators.FieldValueValidator

  describe "validate/1" do
    setup do
      computation = user_fixture() |> computation_fixture()
      field_schema = field_schema_fixture(%{definition: %{"type" => "integer"}})

      attrs = %{computation_id: computation.id, field_schema_id: field_schema.id, last_value: 10}
      input = input_fixture(attrs)

      %{input: input}
    end

    test "returns changeset if there is nothing to validate", %{input: input} do
      changeset = Inputs.change_input(input, %{name: "new"})

      assert FieldValueValidator.validate(changeset) == changeset
    end

    test "validates when last_value changes", %{input: input} do
      changeset = Inputs.change_input(input, %{last_value: 30})

      assert FieldValueValidator.validate(changeset).valid? == true
    end

    test "validates when field_schema_id changes and last_value is not nil", %{input: input} do
      field_schema = field_schema_fixture(%{definition: %{type: "string"}, name: "String"})
      changeset = Inputs.change_input(input, %{field_schema_id: field_schema.id})

      assert changeset.valid? == false
      assert changeset.errors != []
    end
  end
end
