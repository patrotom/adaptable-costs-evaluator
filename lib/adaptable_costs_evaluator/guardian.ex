defmodule AdaptableCostsEvaluator.Guardian do
  use Guardian, otp_app: :adaptable_costs_evaluator

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Users

  def subject_for_token(%User{} = user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    try do
      resource = Users.get_user!(id)
      {:ok, resource}
    rescue
      Ecto.NoResultsError -> {:error, "sub of the token does not exist"}
    end
  end

  def resource_from_claims(_) do
    {:error, :reason_for_error}
  end
end
