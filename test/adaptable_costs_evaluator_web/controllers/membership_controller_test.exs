defmodule AdaptableCostsEvaluatorWeb.MembershipControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Membership

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:membership) do
    {:ok, membership} = Organizations.create_membership(@create_attrs)
    membership
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all memberships", %{conn: conn} do
      conn = get(conn, Routes.membership_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create membership" do
    test "renders membership when data is valid", %{conn: conn} do
      conn = post(conn, Routes.membership_path(conn, :create), membership: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.membership_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.membership_path(conn, :create), membership: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update membership" do
    setup [:create_membership]

    test "renders membership when data is valid", %{conn: conn, membership: %Membership{id: id} = membership} do
      conn = put(conn, Routes.membership_path(conn, :update, membership), membership: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.membership_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, membership: membership} do
      conn = put(conn, Routes.membership_path(conn, :update, membership), membership: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete membership" do
    setup [:create_membership]

    test "deletes chosen membership", %{conn: conn, membership: membership} do
      conn = delete(conn, Routes.membership_path(conn, :delete, membership))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.membership_path(conn, :show, membership))
      end
    end
  end

  defp create_membership(_) do
    membership = fixture(:membership)
    %{membership: membership}
  end
end
