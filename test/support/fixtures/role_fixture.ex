defmodule AdaptableCostsEvaluator.Fixtures.RoleFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Organizations

  using do
    quote do
      def role_fixture(organization_id, user_id, role_type) do
        attrs = %{"role_type" => role_type}
        {:ok, role} = Organizations.create_role(organization_id, user_id, attrs)

        role
      end
    end
  end
end
