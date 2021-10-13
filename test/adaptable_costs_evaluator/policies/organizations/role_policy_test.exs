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

  describe "authorize/3 with list action" do
    test "authorizes regular", context do
      assert authorize(:list, context[:user], context[:organization].id) == true
    end

    test "authorizes maintainer", context do
      Organizations.delete_role(:regular, context[:organization].id, context[:user].id)

      Organizations.create_role(context[:organization].id, context[:user].id, %{
        "type" => "maintainer"
      })

      assert authorize(:list, context[:user], context[:organization].id) == true
    end

    test "authorizes owner", context do
      Organizations.delete_role(:regular, context[:organization].id, context[:user].id)

      Organizations.create_role(context[:organization].id, context[:user].id, %{
        "type" => "owner"
      })

      assert authorize(:list, context[:user], context[:organization].id) == true
    end
  end

  describe "authorize/3 with create, update and delete actions for the regular role" do
    test "authorizes executive", context do
      Organizations.create_role(context[:organization].id, context[:user].id, %{
        "type" => "maintainer"
      })

      Enum.each([:create, :update, :delete], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "regular",
                 "organization_id" => context[:organization].id
               }) == true
      end)
    end

    test "does not authorize regular", context do
      Enum.each([:create, :update, :delete], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "regular",
                 "organization_id" => context[:organization].id
               }) == false
      end)
    end
  end

  describe "authorize/3 with create, update and delete actions for executive roles" do
    test "authorizes owner", context do
      Organizations.create_role(context[:organization].id, context[:user].id, %{
        "type" => "owner"
      })

      Enum.each([:create, :update, :delete], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "maintainer",
                 "organization_id" => context[:organization].id
               }) == true
      end)
    end

    test "does not authorize maintainer", context do
      Organizations.create_role(context[:organization].id, context[:user].id, %{
        "type" => "maintainer"
      })

      Enum.each([:create, :update, :delete], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "maintainer",
                 "organization_id" => context[:organization].id
               }) == false
      end)
    end

    test "does not authorize regular", context do
      Enum.each([:create, :update, :delete], fn action ->
        assert authorize(action, context[:user], %{
                 "type" => "maintainer",
                 "organization_id" => context[:organization].id
               }) == false
      end)
    end
  end
end
