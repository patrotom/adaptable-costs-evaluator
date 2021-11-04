defmodule AdaptableCostsEvaluatorWeb.ComputationController do
  use AdaptableCostsEvaluatorWeb, :controller

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.Computations
  alias AdaptableCostsEvaluator.Computations.Computation

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, %{"organization_id" => organization_id}) do
    with :ok <-
           Bodyguard.permit(Computation, :organization_list, current_user(conn), organization_id) do
      computations = Computations.list_computations(organization_id: organization_id)
      render(conn, "index.json", computations: computations)
    end
  end

  def index(conn, %{"creator_id" => creator_id}) do
    with :ok <- Bodyguard.permit(Computation, :list, current_user(conn), creator_id) do
      computations = Computations.list_computations(creator_id: creator_id)
      render(conn, "index.json", computations: computations)
    end
  end

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

  def show(conn, %{"id" => id}) do
    computation = Computations.get_computation!(id)

    with :ok <- Bodyguard.permit(Computation, :read, current_user(conn), computation.id) do
      render(conn, "show.json", computation: computation)
    end
  end

  def update(conn, %{"id" => id, "computation" => computation_params}) do
    computation = Computations.get_computation!(id)

    with :ok <- Bodyguard.permit(Computation, :update, current_user(conn), computation.id),
         {:ok, %Computation{} = computation} <-
           Computations.update_computation(computation, computation_params) do
      render(conn, "show.json", computation: computation)
    end
  end

  def delete(conn, %{"id" => id}) do
    computation = Computations.get_computation!(id)

    with :ok <- Bodyguard.permit(Computation, :delete, current_user(conn), computation.id),
         {:ok, %Computation{}} <- Computations.delete_computation(computation) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"organization_id" => organization_id, "computation_id" => computation_id}) do
    computation = Computations.get_computation_by!(
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
