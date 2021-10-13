defmodule AdaptableCostsEvaluatorWeb.MembershipController do
  use AdaptableCostsEvaluatorWeb, :controller

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.{Organization, Membership}

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  plug :put_view, AdaptableCostsEvaluatorWeb.UserView

  def index(conn, %{"organization_id" => organization_id}) do
    with :ok <- Bodyguard.permit(Organization, :list_users, current_user(conn), organization_id) do
      users = Organizations.list_users(organization_id)
      render(conn, "index.json", users: users)
    end
  end

  def create(conn, %{"organization_id" => organization_id, "user_id" => user_id}) do
    with :ok <- Bodyguard.permit(Membership, :create, current_user(conn), organization_id),
         {:ok, %Membership{}} <- Organizations.create_membership(organization_id, user_id) do
      conn
      |> send_resp(:created, "")
    end
  end

  def delete(conn, %{"organization_id" => organization_id, "user_id" => user_id} = params) do
    with :ok <- Bodyguard.permit(Membership, :delete, current_user(conn), params),
         {:ok, %Membership{}} <- Organizations.delete_membership(organization_id, user_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
