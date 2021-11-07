defmodule AdaptableCostsEvaluatorWeb.FieldSchemaController do
  use AdaptableCostsEvaluatorWeb, :controller

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.FieldSchemas
  alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, _params) do
    with :ok <- Bodyguard.permit(FieldSchema, :list, current_user(conn), nil) do
      field_schemas = FieldSchemas.list_field_schemas()
      render(conn, "index.json", field_schemas: field_schemas)
    end
  end

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

  def show(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(FieldSchema, :read, current_user(conn), nil) do
      field_schema = FieldSchemas.get_field_schema!(id)
      render(conn, "show.json", field_schema: field_schema)
    end
  end

  def update(conn, %{"id" => id, "field_schema" => field_schema_params}) do
    field_schema = FieldSchemas.get_field_schema!(id)

    with :ok <- Bodyguard.permit(FieldSchema, :update, current_user(conn), nil),
         {:ok, %FieldSchema{} = field_schema} <-
           FieldSchemas.update_field_schema(field_schema, field_schema_params) do
      render(conn, "show.json", field_schema: field_schema)
    end
  end

  def delete(conn, %{"id" => id}) do
    field_schema = FieldSchemas.get_field_schema!(id)

    with :ok <- Bodyguard.permit(FieldSchema, :delete, current_user(conn), nil),
         {:ok, %FieldSchema{}} <- FieldSchemas.delete_field_schema(field_schema) do
      send_resp(conn, :no_content, "")
    end
  end
end
