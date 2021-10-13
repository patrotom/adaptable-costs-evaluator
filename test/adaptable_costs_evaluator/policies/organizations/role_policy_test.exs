defmodule AdaptableCostsEvaluator.Policies.Organizations.RolePolicyTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{OrganizationFixture, UserFixture}

  alias AdaptableCostsEvaluator.Organizations
  import AdaptableCostsEvaluator.Policies.Organizations.RolePolicy

  setup do
    user = user_fixture()
    organization = organization_fixture()
    Organizations.create_membership(organization.id, user.id)

    user = Repo.preload(user, memberships: [:roles])
    role = user.memberships |> List.first() |> then(fn m -> m.roles end) |> List.first()

    %{user: user, organization: organization, role: role}
  end

  describe "authorize/3 with read action" do
    test "authorizes regular", context do
      assert authorize(:read, context[:user], context[:role]) == true
    end

    test "authorizes executive", context do
      Organizations.delete_role(:regular, context[:organization].id, context[:user].id)

      Organizations.create_role(context[:organization].id, context[:user].id, %{
        "type" => "maintainer"
      })

      assert authorize(:read, context[:user], context[:role]) == true
    end

    test "does not authorize user without a role", context do
      Organizations.delete_role(:regular, context[:organization].id, context[:user].id)
      assert authorize(:read, context[:user], context[:role]) == false
    end
  end

  describe "authorize/3 with create, update and delete actions for the regular role" do
    test "authorizes executive", context do
      Organizations.create_role(context[:organization].id, context[:user].id, %{
        "type" => "maintainer"
      })

      Enum.each([:create, :update], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "regular",
                 "organization_id" => context[:organization].id
               }) == true
      end)

      assert authorize(:delete, context[:user], context[:role]) == true
    end

    test "does not authorize regular", context do
      Enum.each([:create, :update], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "regular",
                 "organization_id" => context[:organization].id
               }) == false
      end)

      assert authorize(:delete, context[:user], context[:role]) == false
    end
  end

  describe "authorize/3 with create, update and delete actions for executive roles" do
    test "authorizes owner", context do
      {:ok, role} =
        Organizations.create_role(context[:organization].id, context[:user].id, %{
          "type" => "owner"
        })

      Enum.each([:create, :update], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "maintainer",
                 "organization_id" => context[:organization].id
               }) == true
      end)

      assert authorize(:delete, context[:user], role) == true
    end

    test "does not authorize maintainer", context do
      {:ok, role} =
        Organizations.create_role(context[:organization].id, context[:user].id, %{
          "type" => "maintainer"
        })

      Enum.each([:create, :update], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "maintainer",
                 "organization_id" => context[:organization].id
               }) == false
      end)

      assert authorize(:delete, context[:user], role) == false
    end

    test "does not authorize regular", context do
      Enum.each([:create, :update], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "maintainer",
                 "organization_id" => context[:organization].id
               }) == false
      end)

      assert authorize(:delete, context[:user], context[:role]) == false
    end
  end
end
