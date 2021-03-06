defmodule AdaptableCostsEvaluator.Policies.Organizations.MembershipPolicyTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{OrganizationFixture, UserFixture}

  alias AdaptableCostsEvaluator.Organizations
  import AdaptableCostsEvaluator.Policies.Organizations.MembershipPolicy

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

  describe "authorize/3 with delete action" do
    test "authorizes regular if it is their membership and an executive role", context do
      params = %{"user_id" => context[:user1].id, "organization_id" => context[:organization].id}

      Organizations.create_role(context[:organization].id, context[:user2].id, %{
        "type" => "maintainer"
      })

      assert authorize(:delete, context[:user1], params) == true
    end

    test "does not authorize maintainer if the user is owner", context do
      Organizations.create_role(context[:organization].id, context[:user1].id, %{
        "type" => "owner"
      })

      Organizations.create_role(context[:organization].id, context[:user2].id, %{
        "type" => "maintainer"
      })

      params = %{"user_id" => context[:user1].id, "organization_id" => context[:organization].id}

      assert authorize(:delete, context[:user2], params) == false
    end
  end

  describe "authorize/3 with create actions" do
    test "authorizes an executive role of the organization", context do
      Organizations.create_role(context[:organization].id, context[:user1].id, %{
        "type" => "maintainer"
      })

      assert authorize(:create, context[:user1], context[:organization].id) == true
    end

    test "does not authorize regular", context do
      assert authorize(:create, context[:user1], context[:organization].id) == false
    end
  end

  describe "authorize/3 with list action" do
    test "authorizes member of the organization", context do
      assert authorize(:list, context[:user1], context[:organization].id) == true
    end

    test "does not authorize user outside the organization", context do
      List.first(context[:user1].memberships) |> Repo.delete!()
      assert authorize(:list, context[:user1], context[:organization].id) == false
    end
  end
end
