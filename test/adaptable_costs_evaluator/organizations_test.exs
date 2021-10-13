defmodule AdaptableCostsEvaluator.OrganizationsTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture,
                                        OrganizationFixture,
                                        MembershipFixture}

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
      assert {:ok, %Organization{} = organization} = Organizations.create_organization(@valid_organization_attrs)
      assert organization.name == "some name"
      assert organization.username == "some_username"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_organization_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{} = organization} = Organizations.update_organization(organization, @update_organization_attrs)
      assert organization.name == "some updated name"
      assert organization.username == "some_updated_username"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(organization, @invalid_organization_attrs)
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

    test "list_users/0 returns all users in organization", %{user: user, organization: organization} do
      membership_fixture(organization.id, user.id)
      assert Organizations.list_users(organization.id) == [Users.get_user!(user.id)]
    end

    test "create_membership/1 with valid data creates a membership", %{user: user, organization: organization} do
      assert {:ok, %Membership{} = membership} = Organizations.create_membership(organization.id, user.id)
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
  end

  # describe "roles" do
  #   alias AdaptableCostsEvaluator.Organizations.Role

  #   @valid_attrs %{type: "some type"}
  #   @update_attrs %{type: "some updated type"}
  #   @invalid_attrs %{type: nil}

  #   def role_fixture(attrs \\ %{}) do
  #     {:ok, role} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Organizations.create_role()

  #     role
  #   end

  #   test "list_roles/0 returns all roles" do
  #     role = role_fixture()
  #     assert Organizations.list_roles() == [role]
  #   end

  #   test "get_role!/1 returns the role with given id" do
  #     role = role_fixture()
  #     assert Organizations.get_role!(role.id) == role
  #   end

  #   test "create_role/1 with valid data creates a role" do
  #     assert {:ok, %Role{} = role} = Organizations.create_role(@valid_attrs)
  #     assert role.type == "some type"
  #   end

  #   test "create_role/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Organizations.create_role(@invalid_attrs)
  #   end

  #   test "update_role/2 with valid data updates the role" do
  #     role = role_fixture()
  #     assert {:ok, %Role{} = role} = Organizations.update_role(role, @update_attrs)
  #     assert role.type == "some updated type"
  #   end

  #   test "update_role/2 with invalid data returns error changeset" do
  #     role = role_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Organizations.update_role(role, @invalid_attrs)
  #     assert role == Organizations.get_role!(role.id)
  #   end

  #   test "delete_role/1 deletes the role" do
  #     role = role_fixture()
  #     assert {:ok, %Role{}} = Organizations.delete_role(role)
  #     assert_raise Ecto.NoResultsError, fn -> Organizations.get_role!(role.id) end
  #   end

  #   test "change_role/1 returns a role changeset" do
  #     role = role_fixture()
  #     assert %Ecto.Changeset{} = Organizations.change_role(role)
  #   end
  # end
end
