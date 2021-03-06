defmodule AdaptableCostsEvaluatorWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AdaptableCostsEvaluatorWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AdaptableCostsEvaluatorWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(AdaptableCostsEvaluatorWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(AdaptableCostsEvaluatorWeb.ErrorView)
    |> render("401.json")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(AdaptableCostsEvaluatorWeb.ErrorView)
    |> render("403.json")
  end

  def call(conn, {:error, {:unprocessable_entity, errors}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AdaptableCostsEvaluatorWeb.ErrorView)
    |> render("422.json", errors: errors)
  end
end
