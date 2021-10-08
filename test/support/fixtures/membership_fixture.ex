defmodule AdaptableCostsEvaluator.Fixtures.MembershipFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Organizations

  using do
    quote do
      def membership_fixture(organization_id, user_id) do
        {:ok, membership} = Organizations.create_membership(organization_id, user_id)

        membership
      end
    end
  end
end
