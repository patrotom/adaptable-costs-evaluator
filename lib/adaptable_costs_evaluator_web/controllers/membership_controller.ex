defmodule AdaptableCostsEvaluatorWeb.MembershipController do
  use AdaptableCostsEvaluatorWeb, :controller

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Membership

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  plug :put_view, AdaptableCostsEvaluatorWeb.UserView

  def index(conn, %{"organization_id" => organization_id}) do
    users = Organizations.list_users(organization_id)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"organization_id" => organization_id, "user_id" => user_id}) do
    with {:ok, %Membership{}} <- Organizations.create_membership(organization_id, user_id) do
      conn
      |> send_resp(:created, "")
    end
  end

  def delete(conn, %{"organization_id" => organization_id, "user_id" => user_id}) do
    with {:ok, %Membership{}} <- Organizations.delete_membership(organization_id, user_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
