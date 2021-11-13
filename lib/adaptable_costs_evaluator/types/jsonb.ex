defmodule AdaptableCostsEvaluator.Types.JSONB do
  use Ecto.Type

  @impl true
  def type, do: :map

  @impl true
  def cast(any), do: {:ok, any}

  @impl true
  def load(value), do: Jason.decode(value)

  @impl true
  def dump(value), do: Jason.encode(value)
end
