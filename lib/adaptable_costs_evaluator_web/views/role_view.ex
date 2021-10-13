defmodule AdaptableCostsEvaluatorWeb.RoleView do
  use AdaptableCostsEvaluatorWeb, :view
  alias AdaptableCostsEvaluatorWeb.RoleView

  def render("index.json", %{roles: roles}) do
    %{data: render_many(roles, RoleView, "role.json")}
  end

  def render("role.json", %{role: role}) do
    %{type: role.type}
  end
end
