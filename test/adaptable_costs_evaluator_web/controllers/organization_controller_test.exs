defmodule AdaptableCostsEvaluatorWeb.OrganizationControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture, OrganizationFixture}

  alias AdaptableCostsEvaluator.{Repo, Organizations}
  alias AdaptableCostsEvaluator.Organizations.Organization

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user_fixture()
    |> setup_authd_conn(conn)
  end

  describe "index" do
    test "lists all organizations", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, Routes.organization_path(conn, :create), organization: @valid_organization_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.organization_path(conn, :show, id))
      organization = Organizations.get_organization!(id)

      assert json_response(conn, 200)["data"] == organization_response(organization)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.organization_path(conn, :create), organization: @invalid_organization_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "renders organization when data is valid", %{conn: conn, organization: %Organization{id: id} = organization} do
      conn = put(conn, Routes.organization_path(conn, :update, organization), organization: @update_organization_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.organization_path(conn, :show, id))
      organization = Repo.reload!(organization)

      assert json_response(conn, 200)["data"] == organization_response(organization)
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = put(conn, Routes.organization_path(conn, :update, organization), organization: @invalid_organization_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, Routes.organization_path(conn, :delete, organization))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.organization_path(conn, :show, organization))
      end
    end
  end

  defp create_organization(_) do
    organization = organization_fixture()
    %{organization: organization}
  end
end
