defmodule AdaptableCostsEvaluatorWeb.UserView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    data = %{id: user.id,
             first_name: user.first_name,
             middle_name: user.middle_name,
             last_name: user.last_name,
             email: user.credential.email}

    if user.token != nil, do: Map.put(data, :token, user.token), else: data
  end

  def render("token.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
