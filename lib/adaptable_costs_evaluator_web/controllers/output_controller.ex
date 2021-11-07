defmodule AdaptableCostsEvaluatorWeb.OutputController do
  use AdaptableCostsEvaluatorWeb, :controller

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.{Outputs, Computations}
  alias AdaptableCostsEvaluator.Outputs.Output

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, %{"computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Output, :list, current_user(conn), computation) do
      outputs = Outputs.list_outputs(computation)
      render(conn, "index.json", outputs: outputs)
    end
  end

  def create(conn, %{"output" => output_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    output_params = Map.put(output_params, "computation_id", computation_id)

    with :ok <- Bodyguard.permit(Output, :create, current_user(conn), computation),
         {:ok, %Output{} = output} <- Outputs.create_output(output_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.computation_output_path(conn, :show, computation_id, output))
      |> render("show.json", output: output)
    end
  end

  def show(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Output, :read, current_user(conn), computation) do
      output = Outputs.get_output!(id, computation)
      render(conn, "show.json", output: output)
    end
  end

  def update(conn, %{"id" => id, "output" => output_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    output = Outputs.get_output!(id, computation)

    with :ok <- Bodyguard.permit(Output, :update, current_user(conn), computation),
         {:ok, %Output{} = output} <- Outputs.update_output(output, output_params) do
      render(conn, "show.json", output: output)
    end
  end

  def delete(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    output = Outputs.get_output!(id, computation)

    with :ok <- Bodyguard.permit(Output, :delete, current_user(conn), computation),
         {:ok, %Output{}} <- Outputs.delete_output(output) do
      send_resp(conn, :no_content, "")
    end
  end

  defp get_computation!(id), do: Computations.get_computation!(id)
end
