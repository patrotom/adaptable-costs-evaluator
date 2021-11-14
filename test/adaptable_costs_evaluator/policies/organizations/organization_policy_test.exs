defmodule AdaptableCostsEvaluator.Policies.Organizations.OrganizationPolicyTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{OrganizationFixture, UserFixture}

  alias AdaptableCostsEvaluator.Organizations
  import AdaptableCostsEvaluator.Policies.Organizations.OrganizationPolicy

  setup do
    user = user_fixture()
    organization = organization_fixture()
    Organizations.create_membership(organization.id, user.id)

    %{user: user, organization: organization}
  end

  describe "authorize/3 with read action" do
    test "authorizes regular", context do
      assert authorize(:read, context[:user], context[:organization].id) == true
      Organizations.delete_role(:regular, context[:organization].id, context[:user].id)
      assert authorize(:read, context[:user], context[:organization].id) == false
    end
  end

  describe "authorize/3 with create action" do
    test "authorizes all users", context do
      assert authorize(:create, context[:user], context[:organization].id) == true
    end
  end

  describe "authorize/3 with update action" do
    test "does not authorize regular", context do
      assert authorize(:update, context[:user], context[:organization].id) == false
    end

    test "authorizes maintainer", context do
      Organizations.create_role(
        context[:organization].id,
        context[:user].id,
        %{"type" => "maintainer"}
      )

      assert authorize(:update, context[:user], context[:organization].id) == true
    end

    test "authorizes owner", context do
      Organizations.create_role(
        context[:organization].id,
        context[:user].id,
        %{"type" => "owner"}
      )

      assert authorize(:update, context[:user], context[:organization].id) == true
    end
  end

  describe "authorize/3 with delete action" do
    test "does not authorize regular", context do
      assert authorize(:update, context[:user], context[:organization].id) == false
    end

    test "does not authorize maintainer", context do
      Organizations.create_role(
        context[:organization].id,
        context[:user].id,
        %{"type" => "maintainer"}
      )

      assert authorize(:delete, context[:user], context[:organization].id) == false
    end

    test "authorizes owner", context do
      Organizations.create_role(
        context[:organization].id,
        context[:user].id,
        %{"type" => "owner"}
      )

      assert authorize(:delete, context[:user], context[:organization].id) == true
    end
  end
end
