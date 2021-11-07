defmodule AdaptableCostsEvaluator.Policies.Computations.ComputationPolicyTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{OrganizationFixture, ComputationFixture, UserFixture}

  alias AdaptableCostsEvaluator.Organizations

  import AdaptableCostsEvaluator.Policies.Computations.ComputationPolicy

  setup do
    user1 = user_fixture()
    user2 = user_fixture(%{credential: %{email: "another@example.com", password: "123456789"}})
    organization = organization_fixture()
    Organizations.create_membership(organization.id, user1.id)
    Organizations.create_membership(organization.id, user2.id)

    computation = computation_fixture(user1, %{"organization_id" => organization.id})

    %{user1: user1, user2: user2, computation: computation}
  end

  describe "authorize/3 with list action" do
    test "authorizes user if they are creator of the computation", context do
      assert authorize(:list, context[:user1], context[:user1].id) == true
    end

    test "does not authorize user that is not the creator", context do
      assert authorize(:list, context[:user2], context[:user1].id) == false
    end
  end

  describe "authorize/3 with organization_list action" do
    test "authorizes user from the organization with a role", context do
      assert authorize(:organization_list, context[:user2], context[:computation].organization_id) ==
               true
    end

    test "does not authorize user outside the organization", context do
      Organizations.delete_membership(context[:computation].organization_id, context[:user2].id)

      assert authorize(:organization_list, context[:user2], context[:computation].organization_id) ==
               false
    end
  end

  describe "authorize/3 with create action" do
    test "authorizes all users" do
      assert authorize(:create, nil, nil) == true
    end
  end

  describe "authorize/3 with organization_create action" do
    setup context do
      params = %{
        computation_id: context[:computation].id,
        organization_id: context[:computation].organization_id
      }

      %{params: params}
    end

    test "authorizes creator if they are member of the organization", context do
      assert authorize(:organization_create, context[:user1], context[:params]) == true
    end

    test "does not authorize creator if they are not member of the organization", context do
      Organizations.delete_membership(context[:computation].organization_id, context[:user1].id)

      assert authorize(:organization_create, context[:user1], context[:params]) == false
    end

    test "does not authorize a different user", context do
      assert authorize(:organization_create, context[:user2], context[:params]) == false
    end
  end

  describe "authorize/3 with delete action" do
    test "authorizes the creator", context do
      assert authorize(:delete, context[:user1], context[:computation].id) == true
    end

    test "does not authorize user who is not the creator", context do
      assert authorize(:delete, context[:user2], context[:computation].id) == false
    end
  end

  describe "authorize/3 with organization_delete action" do
    test "authorizes the creator", context do
      assert authorize(:organization_delete, context[:user1], context[:computation].id) == true
    end

    test "authorizes the executive", context do
      Organizations.create_role(context[:computation].organization_id, context[:user2].id, %{
        "type" => "maintainer"
      })

      assert authorize(:organization_delete, context[:user2], context[:computation].id) == true
    end

    test "does not authorize regular", context do
      assert authorize(:organization_delete, context[:user2], context[:computation].id) == false
    end
  end

  describe "authorize/3 with read and update actions" do
    test "authorizes creator", context do
      Enum.each([:read, :update], fn action ->
        assert authorize(action, context[:user1], context[:computation].id) == true
      end)
    end

    test "authorizes member of the organization", context do
      Enum.each([:read, :update], fn action ->
        assert authorize(action, context[:user2], context[:computation].id) == true
      end)
    end

    test "does not authorize user outside the organization", context do
      Organizations.delete_membership(context[:computation].organization_id, context[:user2].id)

      Enum.each([:read, :update], fn action ->
        assert authorize(action, context[:user2], context[:computation].id) == false
      end)
    end
  end
end
