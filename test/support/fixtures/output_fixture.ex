defmodule AdaptableCostsEvaluator.Fixtures.OutputFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Outputs
  alias AdaptableCostsEvaluator.Outputs.Output

  using do
    quote do
      @valid_output_attrs %{label: "some_label", last_value: nil, name: "some name"}
      @update_output_attrs %{
        label: "some_updated_label",
        last_value: nil,
        name: "some updated name"
      }
      @invalid_output_attrs %{label: nil, last_value: nil, name: nil}

      def output_fixture(attrs \\ %{}) do
        {:ok, output} =
          attrs
          |> Enum.into(@valid_output_attrs)
          |> Outputs.create_output()

        output
      end

      def output_response(%Output{} = output) do
        %{
          "id" => output.id,
          "name" => output.name,
          "label" => output.label,
          "last_value" => output.last_value,
          "field_schema_id" => output.field_schema_id,
          "formula_id" => output.formula_id
        }
      end
    end
  end
end
