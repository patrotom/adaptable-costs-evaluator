defmodule AdaptableCostsEvaluator.Types.JSONB do
  @moduledoc """
  A custom definition of the PostgreSQL JSONB type to be used in `Ecto.Changeset`.
  """

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
