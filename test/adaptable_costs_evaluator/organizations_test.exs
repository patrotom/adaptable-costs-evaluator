defmodule AdaptableCostsEvaluator.OrganizationsTest do
  use AdaptableCostsEvaluator.DataCase

  use AdaptableCostsEvaluator.Fixtures.{
    UserFixture,
    OrganizationFixture,
    MembershipFixture,
    RoleFixture
  }

  alias AdaptableCostsEvaluator.{Organizations, Users}
  alias AdaptableCostsEvaluator.Organizations.Role

  describe "organizations" do
    alias AdaptableCostsEvaluator.Organizations.Organization

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} =
               Organizations.create_organization(@valid_organization_attrs)

      assert organization.name == "some name"
      assert organization.username == "some_username"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Organizations.create_organization(@invalid_organization_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()

      assert {:ok, %Organization{} = organization} =
               Organizations.update_organization(organization, @update_organization_attrs)

      assert organization.name == "some updated name"
      assert organization.username == "some_updated_username"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organizations.update_organization(organization, @invalid_organization_attrs)

      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end

  describe "memberships" do
    alias AdaptableCostsEvaluator.Organizations.Membership

    setup do
      %{user: user_fixture(), organization: organization_fixture()}
    end

    test "list_users/0 returns all users in organization", %{
      user: user,
      organization: organization
    } do
      membership_fixture(organization.id, user.id)
      assert Organizations.list_users(organization.id) == [Users.get_user!(user.id)]
    end

    test "create_membership/1 with valid data creates a membership", %{
      user: user,
      organization: organization
    } do
      assert {:ok, %Membership{} = membership} =
               Organizations.create_membership(organization.id, user.id)

      assert [%Role{type: :regular}] = membership.roles
    end

    test "create_membership/1 with invalid data raises error" do
      assert_raise Ecto.NoResultsError, fn -> Organizations.create_membership(100, 200) end
    end

    test "delete_membership/1 deletes the membership", %{user: user, organization: organization} do
      membership_fixture(organization.id, user.id)
      assert {:ok, %Membership{}} = Organizations.delete_membership(organization.id, user.id)
      assert Organizations.list_users(organization.id) == []
    end

    test "colleagues?/2 checks whether two users are in the same organization", %{
      user: first,
      organization: organization
    } do
      {:ok, second} = Users.create_user(@update_user_attrs)
      Organizations.create_membership(organization.id, first.id)
      Organizations.create_membership(organization.id, second.id)

      assert Organizations.colleagues?(first, second)
    end
  end

  describe "roles" do
    setup do
      user = user_fixture()
      organization = organization_fixture()
      Organizations.create_membership(organization.id, user.id)

      user = Repo.preload(user, memberships: [:roles])

      %{user: user, organization: organization}
    end

    test "list_roles/2 returns all roles of the user in the organization", %{
      user: user,
      organization: organization
    } do
      role = user.memberships |> List.first() |> then(fn m -> m.roles end) |> List.first()

      assert Organizations.list_roles(organization.id, user.id) == [role]
    end

    test "create_role/2 creates a new role within the organization", %{
      user: user,
      organization: organization
    } do
      assert {:ok, %Role{type: :maintainer}} =
               Organizations.create_role(organization.id, user.id, %{"type" => "maintainer"})
    end

    test "delete_role/3 deletes the role of the user within the organization", %{
      user: user,
      organization: organization
    } do
      assert {:ok, %Role{}} = Organizations.delete_role(:regular, organization.id, user.id)
      assert Organizations.list_roles(organization.id, user.id) == []
    end
  end
end
