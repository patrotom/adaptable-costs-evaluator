defmodule AdaptableCostsEvaluator.Fixtures.InputFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Inputs
  alias AdaptableCostsEvaluator.Inputs.Input

  using do
    quote do
      @valid_input_attrs %{label: "some label", last_value: %{}, name: "some name"}
      @update_input_attrs %{label: "some updated label", last_value: %{}, name: "some updated name"}
      @invalid_input_attrs %{label: nil, last_value: nil, name: nil}

      def input_fixture(attrs \\ %{}) do
        {:ok, input} =
          attrs
          |> Enum.into(@valid_input_attrs)
          |> Inputs.create_input()

        input
      end

      def input_response(%Input{} = input) do
        %{
          "id" => input.id,
          "name" => input.name,
          "label" => input.label,
          "last_value" => input.last_value,
          "field_schema_id" => input.field_schema_id,
        }
      end
    end
  end
end
