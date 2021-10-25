defmodule AdaptableCostsEvaluatorWeb.ComputationController do
  use AdaptableCostsEvaluatorWeb, :controller

  alias AdaptableCostsEvaluator.Computations
  alias AdaptableCostsEvaluator.Computations.Computation

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, %{"organization_id" => organization_id}) do
    computations = Computations.list_computations(%{organization_id: organization_id})
    render(conn, "index.json", computations: computations)
  end

  def index(conn, %{"user_id" => user_id}) do
    computations = Computations.list_computations(%{user_id: user_id})
    render(conn, "index.json", computations: computations)
  end

  def create(conn, %{"computation" => computation_params}) do
    with {:ok, %Computation{} = computation} <- Computations.create_computation(computation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.computation_path(conn, :show, computation))
      |> render("show.json", computation: computation)
    end
  end

  def show(conn, %{"id" => id}) do
    computation = Computations.get_computation!(id)
    render(conn, "show.json", computation: computation)
  end

  def update(conn, %{"id" => id, "computation" => computation_params}) do
    computation = Computations.get_computation!(id)

    with {:ok, %Computation{} = computation} <- Computations.update_computation(computation, computation_params) do
      render(conn, "show.json", computation: computation)
    end
  end

  def delete(conn, %{"id" => id}) do
    computation = Computations.get_computation!(id)

    with {:ok, %Computation{}} <- Computations.delete_computation(computation) do
      send_resp(conn, :no_content, "")
    end
  end
end
