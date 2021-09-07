defmodule AdaptableCostsEvaluatorWeb.CredentialController do
  use AdaptableCostsEvaluatorWeb, :controller

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.Credential

  action_fallback AdaptableCostsEvaluatorWeb.FallbackController

  def index(conn, _params) do
    credentials = Users.list_credentials()
    render(conn, "index.json", credentials: credentials)
  end

  def create(conn, %{"credential" => credential_params}) do
    with {:ok, %Credential{} = credential} <- Users.create_credential(credential_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.credential_path(conn, :show, credential))
      |> render("show.json", credential: credential)
    end
  end

  def show(conn, %{"id" => id}) do
    credential = Users.get_credential!(id)
    render(conn, "show.json", credential: credential)
  end

  def update(conn, %{"id" => id, "credential" => credential_params}) do
    credential = Users.get_credential!(id)

    with {:ok, %Credential{} = credential} <- Users.update_credential(credential, credential_params) do
      render(conn, "show.json", credential: credential)
    end
  end

  def delete(conn, %{"id" => id}) do
    credential = Users.get_credential!(id)

    with {:ok, %Credential{}} <- Users.delete_credential(credential) do
      send_resp(conn, :no_content, "")
    end
  end
end
