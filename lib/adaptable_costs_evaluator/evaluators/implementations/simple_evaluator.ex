defmodule AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator do
  @moduledoc """
  Simple `AdaptableCostsEvaluator.Evaluators.Evaluator` implementation based on
  the `Abacus` scripting language.
  """

  alias AdaptableCostsEvaluator.Formulas.Formula
  alias AdaptableCostsEvaluator.Evaluators.Evaluator

  alias AdaptableCostsEvaluator.Inputs

  @behaviour Evaluator

  @inputs_regexp ~r/[a-zA-Z_$][a-zA-Z_$0-9]*/

  @impl Evaluator
  @spec evaluate(%Formula{}) :: {:error, binary} | {:ok, number}
  def evaluate(%Formula{} = formula) do
    inputs = parse_inputs_from_formula(formula)
    invalid_inputs = filter_invalid_inputs(inputs)

    if invalid_inputs != [] do
      invalid_inputs = Enum.map(invalid_inputs, fn i -> "'#{i}'" end)
      {:error, "Invalid inputs: #{Enum.join(invalid_inputs, ", ")}"}
    else
      inputs = inputs_to_values(inputs)

      case Abacus.eval(formula.definition, inputs) do
        {:ok, result} -> {:ok, result}
        _ -> {:error, "Invalid syntax"}
      end
    end
  end

  # Parses `AdaptableCostsEvaluator.Inputs.Input` defined by `label` attribute
  # from the `AdaptableCostsEvaluator.Formulas.Formula` definition.
  defp parse_inputs_from_formula(%Formula{definition: nil}) do
    %{}
  end

  defp parse_inputs_from_formula(%Formula{definition: definition, computation_id: computation_id}) do
    Regex.scan(@inputs_regexp, definition)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.map(fn v -> {v, Inputs.get_by(label: v, computation_id: computation_id)} end)
    |> Enum.into(%{})
  end

  defp filter_invalid_inputs(inputs) do
    Enum.filter(inputs, fn {_, v} -> v == nil end)
    |> Enum.map(fn {k, _} -> k end)
  end

  defp inputs_to_values(inputs) do
    Enum.map(inputs, fn {k, v} -> {k, v.last_value} end)
    |> Enum.into(%{})
  end
end
