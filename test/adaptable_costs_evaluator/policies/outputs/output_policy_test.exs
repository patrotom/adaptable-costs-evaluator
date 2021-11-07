defmodule AdaptableCostsEvaluator.Policies.Outputs.OutputPolicyTest do
  use AdaptableCostsEvaluator.DataCase

  use AdaptableCostsEvaluator.Fixtures.{UserFixture, ComputationFixture}

  import AdaptableCostsEvaluator.Policies.Outputs.OutputPolicy

  setup do
    user = user_fixture()
    computation = computation_fixture(user)

    %{user: user, computation: computation}
  end

  describe "authorize/3 with an action" do
    test "delegates authorization to the computation policy read action", %{
      user: user,
      computation: computation
    } do
      assert authorize(:read, user, computation) == true
    end
  end
end
