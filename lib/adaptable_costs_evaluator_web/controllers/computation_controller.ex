defmodule AdaptableCostsEvaluatorWeb.ComputationController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Computations
  alias AdaptableCostsEvaluator.Computations.Computation

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  tags ["Computations"]
  security [%{"JWT" => []}]

  operation :organization_index,
    summary: "List Computations in the Organization",
    parameters: [Parameters.organization_id()],
    responses:
      [
        ok: {"Computation list response", "application/json", Schemas.ComputationsResponse}
      ] ++ Errors.internal_errors()

  def organization_index(conn, %{"organization_id" => organization_id}) do
    with :ok <-
           Bodyguard.permit(Computation, :organization_list, current_user(conn), organization_id) do
      computations = Computations.list_computations(organization_id: organization_id)
      render(conn, "index.json", computations: computations)
    end
  end

  operation :index,
    summary: "List Computations of the User",
    parameters: [
      creator_id: [
        in: :path,
        type: :integer,
        description: "ID of the user who created the Computations",
        example: 42
      ]
    ],
    responses:
      [
        ok: {"Computation list response", "application/json", Schemas.ComputationsResponse}
      ] ++ Errors.internal_errors()

  def index(conn, %{"creator_id" => creator_id}) do
    with :ok <-
           Bodyguard.permit(Computation, :list, current_user(conn), String.to_integer(creator_id)) do
      computations = Computations.list_computations(creator_id: creator_id)
      render(conn, "index.json", computations: computations)
    end
  end

  operation :create,
    summary: "Create a new Computation",
    request_body:
      {"Computation attributes", "application/json", Schemas.ComputationRequest, required: true},
    responses:
      [
        created: {"Computation response", "application/json", Schemas.ComputationResponse}
      ] ++ Errors.all_errors()

  def create(conn, %{"computation" => computation_params}) do
    with :ok <- Bodyguard.permit(Computation, :create, nil, nil),
         {:ok, %Computation{} = computation} <-
           Computations.create_computation(current_user(conn), computation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.computation_path(conn, :show, computation))
      |> render("show.json", computation: computation)
    end
  end

  operation :organization_create,
    summary: "Add the Computation to the Organization",
    parameters: [Parameters.organization_id(), Parameters.computation_id()],
    responses:
      [
        no_content:
          {"Computation successfully added to the Organization", "application/json", nil}
      ] ++ Errors.internal_errors()

  def organization_create(conn, %{
        "organization_id" => organization_id,
        "computation_id" => computation_id
      }) do
    computation = Computations.get_computation!(computation_id)
    bodyguard_params = %{computation_id: computation_id, organization_id: organization_id}

    with :ok <-
           Bodyguard.permit(
             Computation,
             :organization_create,
             current_user(conn),
             bodyguard_params
           ),
         {:ok, _} <- Computations.add_computation_to_organization(computation, organization_id) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :show,
    summary: "Retrieve the Computation",
    parameters: [Parameters.id()],
    responses:
      [
        ok: {"Computation response", "application/json", Schemas.ComputationResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id}) do
    computation = Computations.get_computation!(id)

    with :ok <- Bodyguard.permit(Computation, :read, current_user(conn), computation.id) do
      render(conn, "show.json", computation: computation)
    end
  end

  operation :update,
    summary: "Update the Computation",
    parameters: [Parameters.id()],
    request_body:
      {"Computation attributes", "application/json", Schemas.ComputationRequest, required: true},
    responses:
      [
        ok: {"Computation response", "application/json", Schemas.ComputationResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "computation" => computation_params}) do
    computation = Computations.get_computation!(id)

    with :ok <- Bodyguard.permit(Computation, :update, current_user(conn), computation.id),
         {:ok, %Computation{} = computation} <-
           Computations.update_computation(computation, computation_params) do
      render(conn, "show.json", computation: computation)
    end
  end

  operation :delete,
    summary: "Delete the Computation",
    parameters: [Parameters.id()],
    responses:
      [
        no_content: {"Computation was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{"id" => id}) do
    computation = Computations.get_computation!(id)

    with :ok <- Bodyguard.permit(Computation, :delete, current_user(conn), computation.id),
         {:ok, %Computation{}} <- Computations.delete_computation(computation) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :organization_delete,
    summary: "Remove the Computation from the Organization",
    parameters: [Parameters.computation_id(), Parameters.organization_id()],
    responses:
      [
        no_content:
          {"Computation was successfully removed from the Organization", "application/json", nil}
      ] ++ Errors.internal_errors()

  def organization_delete(conn, %{
        "organization_id" => organization_id,
        "computation_id" => computation_id
      }) do
    computation =
      Computations.get_computation_by!(
        organization_id: organization_id,
        id: computation_id
      )

    with :ok <-
           Bodyguard.permit(
             Computation,
             :organization_delete,
             current_user(conn),
             computation.id
           ),
         {:ok, %Computation{}} <- Computations.delete_computation(computation, from_org: true) do
      send_resp(conn, :no_content, "")
    end
  end
end
