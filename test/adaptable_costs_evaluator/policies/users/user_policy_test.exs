defmodule AdaptableCostsEvaluator.Policies.Users.UserPolicyTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{OrganizationFixture, UserFixture}

  alias AdaptableCostsEvaluator.Organizations
  import AdaptableCostsEvaluator.Policies.Users.UserPolicy

  setup do
    user1 = user_fixture()
    user2 = user_fixture(%{credential: %{email: "another@example.com", password: "123456789"}})
    organization = organization_fixture()
    Organizations.create_membership(organization.id, user1.id)
    Organizations.create_membership(organization.id, user2.id)

    user1 = Repo.preload(user1, :memberships)
    user2 = Repo.preload(user2, :memberships)

    %{user1: user1, user2: user2, organization: organization}
  end

  describe "authorize/3 when the user resource is the same as the current user" do
    test "authorizes the current user", context do
      Enum.each([:read, :update, :delete], fn action ->
        assert authorize(action, context[:user1], context[:user1].id) == true
      end)
    end

    test "does not authorize different user", context do
      Organizations.delete_membership(context[:organization].id, context[:user2].id)

      Enum.each([:read, :update, :delete], fn action ->
        assert authorize(action, context[:user2], context[:user1].id) == false
      end)
    end
  end

  describe "authorize/3 when the user colleagues with the current user" do
    test "authorizes for reading", context do
      assert authorize(:read, context[:user2], context[:user1].id) == true
    end
  end

  describe "authorize/3 for the create action" do
    test "authorizes anyone", context do
      Organizations.delete_membership(context[:organization].id, context[:user1].id)
      assert authorize(:create, context[:user1], nil) == true
    end
  end
end
