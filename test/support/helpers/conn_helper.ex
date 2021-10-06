defmodule AdaptableCostsEvaluator.Helpers.ConnHelper do
  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Guardian

  import Plug.Conn, only: [put_req_header: 3]

  def setup_conns(%User{} = user, conn) do
    {_, conn: plain} = setup_plain_conn(conn)
    {_, conn: authd} = setup_authd_conn(user, conn)

    {:ok, conns: %{plain: plain, authd: authd}, user: user}
  end

  def setup_plain_conn(conn) do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  def setup_authd_conn(%User{} = user, conn) do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
    {_, conn: plain} = setup_plain_conn(conn)

    conn =
      plain
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, conn: conn}
  end
end
