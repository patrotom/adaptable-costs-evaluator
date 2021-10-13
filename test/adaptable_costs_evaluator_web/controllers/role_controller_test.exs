defmodule AdaptableCostsEvaluatorWeb.RoleControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  use AdaptableCostsEvaluator.Fixtures.{UserFixture,
                                        OrganizationFixture,
                                        MembershipFixture,
                                        RoleFixture}

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    organization = organization_fixture()
    role = membership_fixture(organization.id, user.id) |> then(fn m -> m.roles end) |> List.first()
    {:ok, conn: conn} = setup_authd_conn(user, conn)
    %{conn: conn, user: user, organization: organization, role: role}
  end

  describe "index" do
    test "lists all roles of user in organization", %{
      conn: conn,
      user: user,
      organization: organization,
      role: role
    } do
      conn = get(conn, Routes.role_path(conn, :index, organization.id, user.id))
      assert json_response(conn, 200)["data"] == [role_response(role)]
    end
  end

  describe "create role" do
    test "creates new role for the user in the organization", %{
      conn: conn,
      user: user,
      organization: organization,
      role: _
    } do
      params = %{"role" => %{"type" => "owner"}}
      conn = post(conn, Routes.role_path(conn, :create, organization.id, user.id), params)
      assert response(conn, 201)
    end
  end

  describe "delete role" do
    test "deletes existing role of the user in the organization", %{
      conn: conn,
      user: user,
      organization: organization,
      role: role
    } do
      conn = delete(conn, Routes.role_path(conn, :delete, organization.id, user.id), role: role_response(role))
      assert response(conn, 204)
    end
  end
end
