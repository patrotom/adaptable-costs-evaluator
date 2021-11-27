defmodule AdaptableCostsEvaluatorWeb.OrganizationController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Organization

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["Organizations"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all Organizations",
    responses:
      [
        ok: {"Organizations list response", "application/json", Schemas.OrganizationsResponse}
      ] ++ Errors.internal_errors()

  def index(conn, _params) do
    with :ok <- Bodyguard.permit(Organization, :list, current_user(conn), nil) do
      organizations = Organizations.list_organizations()
      render(conn, "index.json", organizations: organizations)
    end
  end

  operation :create,
    summary: "Create a new Organization",
    request_body:
      {"Organization attributes", "application/json", Schemas.OrganizationRequest, required: true},
    responses:
      [
        created: {"Organization response", "application/json", Schemas.OrganizationResponse}
      ] ++ Errors.all_errors()

  def create(conn, %{"organization" => organization_params}) do
    with :ok <- Bodyguard.permit(Organization, :create, current_user(conn), nil),
         {:ok, %Organization{} = organization} <-
           Organizations.create_organization(organization_params),
         {:ok, _} <- Organizations.create_membership(organization.id, current_user(conn).id),
         {:ok, _} <-
           Organizations.create_role(organization.id, current_user(conn).id, %{"type" => "owner"}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.organization_path(conn, :show, organization))
      |> render("show.json", organization: organization)
    end
  end

  operation :show,
    summary: "Retrieve the Organization",
    parameters: [Parameters.id()],
    responses:
      [
        ok: {"Organization response", "application/json", Schemas.OrganizationResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(Organization, :read, current_user(conn), id) do
      organization = Organizations.get_organization!(id)
      render(conn, "show.json", organization: organization)
    end
  end

  operation :update,
    summary: "Update the Organization",
    parameters: [Parameters.id()],
    request_body:
      {"Organization attributes", "application/json", Schemas.OrganizationRequest, required: true},
    responses:
      [
        ok: {"Organization response", "application/json", Schemas.OrganizationResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Organizations.get_organization!(id)

    with :ok <- Bodyguard.permit(Organization, :update, current_user(conn), id),
         {:ok, %Organization{} = organization} <-
           Organizations.update_organization(organization, organization_params) do
      render(conn, "show.json", organization: organization)
    end
  end

  operation :delete,
    summary: "Delete the Organization",
    parameters: [Parameters.id()],
    responses:
      [
        no_content: {"Organization was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)

    with :ok <- Bodyguard.permit(Organization, :delete, current_user(conn), id),
         {:ok, %Organization{}} <- Organizations.delete_organization(organization) do
      send_resp(conn, :no_content, "")
    end
  end
end
