defmodule AdaptableCostsEvaluator.Policies.BasePolicy do
  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.User

  defmacro __using__(_opts) do
    quote do
      def authorize(_, %User{admin: true}, _), do: true

      defp executive?(user_id, organization_id) do
        Users.has_role?(:owner, user_id, organization_id) ||
          Users.has_role?(:maintainer, user_id, organization_id)
      end
    end
  end
end
