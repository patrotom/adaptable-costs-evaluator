defmodule AdaptableCostsEvaluatorWeb.Handlers.JWTAuthHandler do
  import Plug.Conn

  alias AdaptableCostsEvaluatorWeb.ErrorView

  def auth_error(conn, {type, _reason}, _opts) do
    body =
      ErrorView.render("401.json", %{errors: [to_string(type)]})
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
