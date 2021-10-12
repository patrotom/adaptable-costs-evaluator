defmodule AdaptableCostsEvaluatorWeb.RoleController do
  use AdaptableCostsEvaluatorWeb, :controller

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Role

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, %{"user_id" => user_id, "organization_id" => organization_id}) do
    roles = Organizations.list_roles(organization_id, user_id)
    render(conn, "index.json", roles: roles)
  end

  def create(conn, %{
        "role" => role_params,
        "user_id" => user_id,
        "organization_id" => organization_id
      }) do
    with {:ok, %Role{}} <- Organizations.create_role(organization_id, user_id, role_params) do
      conn
      |> send_resp(:created, "")
    end
  end

  def delete(conn, %{
        "role" => %{"type" => role_type},
        "user_id" => user_id,
        "organization_id" => organization_id
      }) do
    with {:ok, %Role{}} <- Organizations.delete_role(role_type, organization_id, user_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
