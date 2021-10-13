defmodule AdaptableCostsEvaluatorWeb.Helpers.AuthHelper do
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
