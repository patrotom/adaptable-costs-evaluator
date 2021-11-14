defmodule AdaptableCostsEvaluatorWeb.OrganizationController do
  use AdaptableCostsEvaluatorWeb, :controller

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Organization

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, _params) do
    with :ok <- Bodyguard.permit(Organization, :list, current_user(conn), nil) do
      organizations = Organizations.list_organizations()
      render(conn, "index.json", organizations: organizations)
    end
  end

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

  def show(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(Organization, :read, current_user(conn), id) do
      organization = Organizations.get_organization!(id)
      render(conn, "show.json", organization: organization)
    end
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Organizations.get_organization!(id)

    with :ok <- Bodyguard.permit(Organization, :update, current_user(conn), id),
         {:ok, %Organization{} = organization} <-
           Organizations.update_organization(organization, organization_params) do
      render(conn, "show.json", organization: organization)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)

    with :ok <- Bodyguard.permit(Organization, :delete, current_user(conn), id),
         {:ok, %Organization{}} <- Organizations.delete_organization(organization) do
      send_resp(conn, :no_content, "")
    end
  end
end
