defmodule AdaptableCostsEvaluatorWeb.PageController do
  use AdaptableCostsEvaluatorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
