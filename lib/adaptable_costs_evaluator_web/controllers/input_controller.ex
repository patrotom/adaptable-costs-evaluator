defmodule AdaptableCostsEvaluatorWeb.InputController do
  use AdaptableCostsEvaluatorWeb, :controller

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.{Inputs, Computations}
  alias AdaptableCostsEvaluator.Inputs.Input

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, %{"computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Input, :list, current_user(conn), computation) do
      inputs = Inputs.list_inputs(computation)
      render(conn, "index.json", inputs: inputs)
    end
  end

  def create(conn, %{"input" => input_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    input_params = Map.put(input_params, "computation_id", computation_id)

    with :ok <- Bodyguard.permit(Input, :create, current_user(conn), computation),
         {:ok, %Input{} = input} <- Inputs.create_input(input_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.computation_input_path(conn, :show, computation_id, input)
      )
      |> render("show.json", input: input)
    end
  end

  def show(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Input, :read, current_user(conn), computation) do
      input = Inputs.get_input!(id, computation)
      render(conn, "show.json", input: input)
    end
  end

  def update(conn, %{"id" => id, "input" => input_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    input = Inputs.get_input!(id, computation)

    with :ok <- Bodyguard.permit(Input, :update, current_user(conn), computation),
         {:ok, %Input{} = input} <- Inputs.update_input(input, input_params) do
      render(conn, "show.json", input: input)
    end
  end

  def delete(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    input = Inputs.get_input!(id, computation)

    with :ok <- Bodyguard.permit(Input, :delete, current_user(conn), computation),
         {:ok, %Input{}} <- Inputs.delete_input(input) do
      send_resp(conn, :no_content, "")
    end
  end

  defp get_computation!(id), do: Computations.get_computation!(id)
end
