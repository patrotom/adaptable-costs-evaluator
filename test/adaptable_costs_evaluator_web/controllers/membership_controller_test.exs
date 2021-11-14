defmodule AdaptableCostsEvaluatorWeb.MembershipControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture, OrganizationFixture, MembershipFixture}

  alias AdaptableCostsEvaluator.Organizations

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    organization = organization_fixture()
    {:ok, conn: conn} = setup_authd_conn(user, conn)
    %{conn: conn, user: user, organization: organization}
  end

  describe "index" do
    test "lists all users in organization", %{conn: conn, user: user, organization: organization} do
      membership_fixture(organization.id, user.id)

      conn = get(conn, Routes.membership_path(conn, :index, organization.id))
      assert json_response(conn, 200)["data"] == [user_response(user)]
    end
  end

  describe "create membership" do
    test "adds user to organization when data is valid", %{
      conn: conn,
      user: user,
      organization: organization
    } do
      conn = post(conn, Routes.membership_path(conn, :create, organization.id, user.id))
      assert response(conn, 201)

      conn = get(conn, Routes.membership_path(conn, :index, organization.id))
      assert json_response(conn, 200)["data"] == [user_response(user)]
    end
  end

  describe "delete membership" do
    test "deletes user from organization", %{conn: conn, user: user, organization: organization} do
      membership_fixture(organization.id, user.id)

      conn = delete(conn, Routes.membership_path(conn, :delete, organization.id, user.id))
      assert response(conn, 204)

      assert Organizations.list_users(organization.id) == []
    end
  end
end
