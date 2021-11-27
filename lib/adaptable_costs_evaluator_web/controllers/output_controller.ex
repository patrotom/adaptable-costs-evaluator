defmodule AdaptableCostsEvaluatorWeb.OutputController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.{Outputs, Computations}
  alias AdaptableCostsEvaluator.Outputs.Output

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["Outputs"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all Outputs in the Computation",
    parameters: [Parameters.computation_id()],
    responses:
      [
        ok: {"Outputs list response", "application/json", Schemas.OutputsResponse}
      ] ++ Errors.internal_errors()

  def index(conn, %{"computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Output, :list, current_user(conn), computation) do
      outputs = Outputs.list_outputs(computation)
      render(conn, "index.json", outputs: outputs)
    end
  end

  operation :create,
    summary: "Create a new Output in the Computation",
    parameters: [Parameters.computation_id()],
    request_body:
      {"Output attributes", "application/json", Schemas.OutputRequest, required: true},
    responses:
      [
        created: {"Output response", "application/json", Schemas.OutputResponse}
      ] ++ Errors.all_errors()

  def create(conn, %{"output" => output_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    output_params = Map.put(output_params, "computation_id", computation_id)

    with :ok <- Bodyguard.permit(Output, :create, current_user(conn), computation),
         {:ok, %Output{} = output} <- Outputs.create_output(output_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.computation_output_path(conn, :show, computation_id, output)
      )
      |> render("show.json", output: output)
    end
  end

  operation :show,
    summary: "Retrieve the Output from the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    responses:
      [
        ok: {"Output response", "application/json", Schemas.OutputResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Output, :read, current_user(conn), computation) do
      output = Outputs.get_output!(id, computation)
      render(conn, "show.json", output: output)
    end
  end

  operation :update,
    summary: "Update the Output in the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    request_body:
      {"Output attributes", "application/json", Schemas.OutputRequest, required: true},
    responses:
      [
        ok: {"Output response", "application/json", Schemas.OutputResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "output" => output_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    output = Outputs.get_output!(id, computation)

    with :ok <- Bodyguard.permit(Output, :update, current_user(conn), computation),
         {:ok, %Output{} = output} <- Outputs.update_output(output, output_params) do
      render(conn, "show.json", output: output)
    end
  end

  operation :delete,
    summary: "Delete the Output in the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    responses:
      [
        no_content: {"Output was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

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
