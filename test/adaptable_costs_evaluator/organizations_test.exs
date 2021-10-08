defmodule AdaptableCostsEvaluator.OrganizationsTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.OrganizationFixture

  alias AdaptableCostsEvaluator.Organizations

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

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def membership_fixture(attrs \\ %{}) do
      {:ok, membership} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organizations.create_membership()

      membership
    end

    test "list_memberships/0 returns all memberships" do
      membership = membership_fixture()
      assert Organizations.list_memberships() == [membership]
    end

    test "get_membership!/1 returns the membership with given id" do
      membership = membership_fixture()
      assert Organizations.get_membership!(membership.id) == membership
    end

    test "create_membership/1 with valid data creates a membership" do
      assert {:ok, %Membership{} = membership} = Organizations.create_membership(@valid_attrs)
    end

    test "create_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_membership(@invalid_attrs)
    end

    test "update_membership/2 with valid data updates the membership" do
      membership = membership_fixture()
      assert {:ok, %Membership{} = membership} = Organizations.update_membership(membership, @update_attrs)
    end

    test "update_membership/2 with invalid data returns error changeset" do
      membership = membership_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_membership(membership, @invalid_attrs)
      assert membership == Organizations.get_membership!(membership.id)
    end

    test "delete_membership/1 deletes the membership" do
      membership = membership_fixture()
      assert {:ok, %Membership{}} = Organizations.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_membership!(membership.id) end
    end

    test "change_membership/1 returns a membership changeset" do
      membership = membership_fixture()
      assert %Ecto.Changeset{} = Organizations.change_membership(membership)
    end
  end
end
