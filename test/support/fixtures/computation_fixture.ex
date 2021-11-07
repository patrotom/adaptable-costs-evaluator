defmodule AdaptableCostsEvaluator.Fixtures.ComputationFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Computations
  alias AdaptableCostsEvaluator.Computations.Computation
  alias AdaptableCostsEvaluator.Users.User

  using do
    quote do
      @valid_computation_attrs %{"name" => "some name"}
      @update_computation_attrs %{"name" => "some updated name"}
      @invalid_computation_attrs %{"name" => nil}

      def computation_fixture(%User{} = user, attrs \\ %{}) do
        attrs = Enum.into(attrs, @valid_computation_attrs)
        {:ok, computation} = Computations.create_computation(user, attrs)

        computation
      end

      def computation_response(%Computation{} = computation) do
        %{
          "id" => computation.id,
          "name" => computation.name,
          "creator_id" => computation.creator_id,
          "organization_id" => computation.organization_id,
        }
      end
    end
  end
end
