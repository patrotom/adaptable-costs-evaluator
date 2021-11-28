defmodule AdaptableCostsEvaluatorWeb.InputController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.{Inputs, Computations}
  alias AdaptableCostsEvaluator.Inputs.Input

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["Inputs"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all Inputs in the Computation",
    parameters: [Parameters.computation_id()],
    responses:
      [
        ok: {"Inputs list response", "application/json", Schemas.InputsResponse}
      ] ++ Errors.internal_errors()

  def index(conn, %{"computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Input, :list, current_user(conn), computation) do
      inputs = Inputs.list_inputs(computation)
      render(conn, "index.json", inputs: inputs)
    end
  end

  operation :create,
    summary: "Create a new Input in the Computation",
    parameters: [Parameters.computation_id()],
    request_body: {"Input attributes", "application/json", Schemas.InputRequest, required: true},
    responses:
      [
        created: {"Input response", "application/json", Schemas.InputResponse}
      ] ++ Errors.all_errors()

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

  operation :show,
    summary: "Retrieve the Input from the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    responses:
      [
        ok: {"Input response", "application/json", Schemas.InputResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)

    with :ok <- Bodyguard.permit(Input, :read, current_user(conn), computation) do
      input = Inputs.get_input!(id, computation)
      render(conn, "show.json", input: input)
    end
  end

  operation :update,
    summary: "Update the Input in the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    request_body: {"Input attributes", "application/json", Schemas.InputRequest, required: true},
    responses:
      [
        ok: {"Input response", "application/json", Schemas.InputResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "input" => input_params, "computation_id" => computation_id}) do
    computation = get_computation!(computation_id)
    input = Inputs.get_input!(id, computation)

    with :ok <- Bodyguard.permit(Input, :update, current_user(conn), computation),
         {:ok, %Input{} = input} <- Inputs.update_input(input, input_params) do
      render(conn, "show.json", input: input)
    end
  end

  operation :delete,
    summary: "Delete the Input in the Computation",
    parameters: [Parameters.id(), Parameters.computation_id()],
    responses:
      [
        no_content: {"Input was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

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
