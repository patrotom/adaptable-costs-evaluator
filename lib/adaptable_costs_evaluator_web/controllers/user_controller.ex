defmodule AdaptableCostsEvaluatorWeb.UserController do
  use AdaptableCostsEvaluatorWeb, :controller
  use OpenApiSpex.ControllerSpecs

  import AdaptableCostsEvaluatorWeb.Helpers.AuthHelper, only: [current_user: 1]

  alias AdaptableCostsEvaluator.{Users, Guardian}
  alias AdaptableCostsEvaluator.Users.User

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  alias AdaptableCostsEvaluatorWeb.ApiSpec.{Schemas, Parameters, Errors}

  tags ["Users"]

  operation :index,
    summary: "List all Users",
    security: [%{"JWT" => []}],
    responses:
      [
        ok: {"Users list response", "application/json", Schemas.UsersResponse}
      ] ++ Errors.internal_errors()

  def index(conn, _params) do
    with :ok <- Bodyguard.permit(User, :list, current_user(conn), nil) do
      users = Users.list_users()
      render(conn, "index.json", users: users)
    end
  end

  operation :create,
    summary: "Create a new User",
    request_body: {"User attributes", "application/json", Schemas.UserRequest, required: true},
    responses:
      [
        created: {"User response with token", "application/json", Schemas.UserTokenResponse}
      ] ++ Errors.all_errors()

  def create(conn, %{"user" => user_params}) do
    with :ok <- Bodyguard.permit(User, :create, nil, nil),
         {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: %{user | token: token})
    end
  end

  operation :show,
    summary: "Retrieve the User",
    parameters: [Parameters.id()],
    security: [%{"JWT" => []}],
    responses:
      [
        ok: {"User response", "application/json", Schemas.UserResponse}
      ] ++ Errors.internal_errors()

  def show(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(User, :read, current_user(conn), String.to_integer(id)) do
      user = Users.get_user!(id)
      render(conn, "show.json", user: user)
    end
  end

  operation :update,
    summary: "Update the User",
    parameters: [Parameters.id()],
    security: [%{"JWT" => []}],
    request_body: {"User attributes", "application/json", Schemas.UserRequest, required: true},
    responses:
      [
        ok: {"User response", "application/json", Schemas.UserResponse}
      ] ++ Errors.all_errors()

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with :ok <- Bodyguard.permit(User, :update_admin, current_user(conn), user_params),
         :ok <- Bodyguard.permit(User, :update, current_user(conn), user.id),
         {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  operation :delete,
    summary: "Delete the User",
    parameters: [Parameters.id()],
    security: [%{"JWT" => []}],
    responses:
      [
        no_content: {"User was successfully deleted", "application/json", nil}
      ] ++ Errors.internal_errors()

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with :ok <- Bodyguard.permit(User, :delete, current_user(conn), user.id),
         {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  operation :sign_in,
    summary: "Sign in the User",
    request_body:
      {"Sign-in attributes", "application/json", Schemas.SignInRequest, required: true},
    responses:
      [
        ok: {"Sign-in response", "application/json", Schemas.SignInResponse}
      ] ++ Errors.internal_errors()

  def sign_in(conn, %{"data" => %{"email" => email, "password" => password}}) do
    case Users.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn
        |> render("token.json", token: token)

      _ ->
        {:error, :unauthorized}
    end
  end

  operation :organizations,
    summary: "List Organizations the User is member of",
    parameters: [Parameters.id()],
    security: [%{"JWT" => []}],
    responses:
      [
        ok: {"Organizations list response", "application/json", Schemas.OrganizationsResponse}
      ] ++ Errors.internal_errors()

  def organizations(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with :ok <- Bodyguard.permit(User, :organizations, current_user(conn), user.id) do
      organizations = Users.list_organizations(user.id)

      conn
      |> put_view(AdaptableCostsEvaluatorWeb.OrganizationView)
      |> render("index.json", organizations: organizations)
    end
  end
end
