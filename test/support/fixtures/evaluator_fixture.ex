defmodule AdaptableCostsEvaluator.Fixtures.EvaluatorFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Evaluators
  alias AdaptableCostsEvaluator.Evaluators.Evaluator

  using do
    quote do
      @valid_evaluator_attrs %{
        description: "some description",
        module: "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator",
        name: "some name"
      }
      @update_evaluator_attrs %{
        description: "some updated description",
        module: "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator",
        name: "some updated name"
      }
      @invalid_evaluator_attrs %{description: nil, module: nil, name: nil}

      def evaluator_fixture(attrs \\ %{}) do
        {:ok, evaluator} =
          attrs
          |> Enum.into(@valid_evaluator_attrs)
          |> Evaluators.create_evaluator()

        evaluator
      end

      def evaluator_response(%Evaluator{} = evaluator) do
        %{
          "id" => evaluator.id,
          "name" => evaluator.name,
          "description" => evaluator.description,
          "module" => evaluator.module
        }
      end
    end
  end
end
