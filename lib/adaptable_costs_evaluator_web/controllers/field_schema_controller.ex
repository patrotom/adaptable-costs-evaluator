defmodule AdaptableCostsEvaluatorWeb.FieldSchemaController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.FieldSchemas
  alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["FieldSchemas"]
  security [%{"JWT" => []}]

  operation :index,
    summary: "List all FieldSchemas",
    responses:
      [
        ok: {"FieldSchemas list response", "application/json", Schemas.FieldSchemasResponse}
      ] ++ Errors.internal_errors()

  def index(conn, _params) do
    with :ok <- Bodyguard.permit(FieldSchema, :list, current_user(conn), nil) do
      field_schemas = FieldSchemas.list_field_schemas()
      render(conn, "index.json", field_schemas: field_schemas)
    end
  end

  operation :create,
    summary: "Create a new FieldSchema",
    request_body:
      {"FieldSchema attributes", "application/json", Schemas.FieldSchemaRequest, required: true},
    responses:
      [
        created: {"FieldSchema response", "application/json", Schemas.FieldSchemaResponse}
      ] ++ Errors.all_errors()

  def create(conn, %{"field_schema" => field_schema_params}) do
    with :ok <- Bodyguard.permit(FieldSchema, :create, current_user(conn), nil),
         {:ok, %FieldSchema{} = field_schema} <-
           FieldSchemas.create_field_schema(field_schema_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.field_schema_path(conn, :show, field_schema))
      |> render("show.json", field_schema: field_schema)
    end
  end

  operation :show,
    summary: "Retrieve the FieldSchema",
    parameters: [Parameters.id()],
    responses:
      [
        ok: {"FieldSchema response", "application/json", Schemas.FieldSchemaResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(FieldSchema, :read, current_user(conn), nil) do
      field_schema = FieldSchemas.get_field_schema!(id)
      render(conn, "show.json", field_schema: field_schema)
    end
  end

  operation :update,
    summary: "Update the FieldSchema",
    parameters: [Parameters.id()],
    request_body:
      {"FieldSchema attributes", "application/json", Schemas.FieldSchemaRequest, required: true},
    responses:
      [
        ok: {"FieldSchema response", "application/json", Schemas.FieldSchemaResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "field_schema" => field_schema_params}) do
    field_schema = FieldSchemas.get_field_schema!(id)

    with :ok <- Bodyguard.permit(FieldSchema, :update, current_user(conn), nil),
         {:ok, %FieldSchema{} = field_schema} <-
           FieldSchemas.update_field_schema(field_schema, field_schema_params) do
      render(conn, "show.json", field_schema: field_schema)
    end
  end

  operation :delete,
    summary: "Delete the FieldSchema",
    parameters: [Parameters.id()],
    responses:
      [
        no_content: {"FieldSchema was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{"id" => id}) do
    field_schema = FieldSchemas.get_field_schema!(id)

    with :ok <- Bodyguard.permit(FieldSchema, :delete, current_user(conn), nil),
         {:ok, %FieldSchema{}} <- FieldSchemas.delete_field_schema(field_schema) do
      send_resp(conn, :no_content, "")
    end
  end
end
