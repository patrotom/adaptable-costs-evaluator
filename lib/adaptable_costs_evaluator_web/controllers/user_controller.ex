defmodule AdaptableCostsEvaluatorWeb.UserController do
  use AdaptableCostsEvaluatorWeb, :controller

  alias AdaptableCostsEvaluator.{Users, Guardian}
  alias AdaptableCostsEvaluator.Users.User

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: %{user | token: token})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"data" => %{"email" => email, "password" => password}}) do
    case Users.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn
        |> render("token.json", token: token)
      _ ->
        {:error, :unauthorized}
    end
  end
end
