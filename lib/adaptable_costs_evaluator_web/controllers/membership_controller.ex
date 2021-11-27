defmodule AdaptableCostsEvaluatorWeb.MembershipController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Membership

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  plug :put_view, AdaptableCostsEvaluatorWeb.UserView

  tags ["Memberships"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all Users in the Organization",
    parameters: [Parameters.organization_id()],
    responses:
      [
        ok: {"Users list response", "application/json", Schemas.UsersResponse}
      ] ++ Errors.internal_errors()

  def index(conn, %{"organization_id" => organization_id}) do
    with :ok <- Bodyguard.permit(Membership, :list, current_user(conn), organization_id) do
      users = Organizations.list_users(organization_id)
      render(conn, "index.json", users: users)
    end
  end

  operation :create,
    summary: "Add User to the Organization",
    parameters: [Parameters.organization_id(), Parameters.user_id()],
    responses:
      [
        created: {"User added to the Organization", "application/json", nil}
      ] ++ Errors.internal_errors()

  def create(conn, %{"organization_id" => organization_id, "user_id" => user_id}) do
    with :ok <- Bodyguard.permit(Membership, :create, current_user(conn), organization_id),
         {:ok, %Membership{}} <- Organizations.create_membership(organization_id, user_id) do
      conn
      |> send_resp(:created, "")
    end
  end

  operation :delete,
    summary: "Remove User from the Organization",
    parameters: [Parameters.organization_id(), Parameters.user_id()],
    responses:
      [
        no_content: {"User removed to the Organization", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{"organization_id" => organization_id, "user_id" => user_id} = params) do
    with :ok <- Bodyguard.permit(Membership, :delete, current_user(conn), params),
         {:ok, %Membership{}} <- Organizations.delete_membership(organization_id, user_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
