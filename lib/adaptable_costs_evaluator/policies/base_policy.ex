defmodule AdaptableCostsEvaluator.Policies.BasePolicy do
  @moduledoc """
  Base policy module that you should `use` in each new policy you define. The Policy
  is a way to handle the authorization in the app. This feature is enabled through
  Bodyguard package.

  For more information, read [Bodyguard docs](https://github.com/schrockwell/bodyguard).
  """

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
