defmodule AdaptableCostsEvaluatorWeb.RoleController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Role

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["Roles"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all Roles of the User in the Organization",
    parameters: [Parameters.user_id(), Parameters.organization_id()],
    responses:
      [
        ok: {"Roles list response", "application/json", Schemas.RolesResponse}
      ] ++ Errors.internal_errors()

  def index(conn, %{"user_id" => user_id, "organization_id" => organization_id}) do
    with :ok <- Bodyguard.permit(Role, :list, current_user(conn), organization_id) do
      roles = Organizations.list_roles(organization_id, user_id)
      render(conn, "index.json", roles: roles)
    end
  end

  operation :create,
    summary: "Create a new Role for the User in the Organization",
    parameters: [Parameters.user_id(), Parameters.organization_id()],
    request_body:
      {"Role attributes", "application/json", Schemas.RoleRequest, required: true},
    responses:
      [
        created: {"Role was successfully created ", "application/json", nil}
      ] ++ Errors.all_errors()

  def create(conn, %{
        "role" => role_params,
        "user_id" => user_id,
        "organization_id" => organization_id
      }) do
    params = Map.merge(role_params, %{"organization_id" => organization_id})

    with :ok <- Bodyguard.permit(Role, :create, current_user(conn), params),
         {:ok, %Role{}} <- Organizations.create_role(organization_id, user_id, role_params) do
      conn
      |> send_resp(:created, "")
    end
  end

  operation :delete,
    summary: "Delete the Role in the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    request_body:
      {"Role to delete", "application/json", Schemas.RoleRequest, required: true},
    responses:
      [
        no_content: {"Role was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{
        "role" => %{"type" => role_type},
        "user_id" => user_id,
        "organization_id" => organization_id
      }) do
    params = %{"type" => role_type, "organization_id" => organization_id}

    with :ok <- Bodyguard.permit(Role, :delete, current_user(conn), params),
         {:ok, %Role{}} <- Organizations.delete_role(role_type, organization_id, user_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
