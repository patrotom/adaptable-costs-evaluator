defmodule AdaptableCostsEvaluator.Guardian do
  @moduledoc """
  Implementation of the Guardian used for the JWT authentication.
  """

  use Guardian, otp_app: :adaptable_costs_evaluator

  alias AdaptableCostsEvaluator.Users.User
  alias AdaptableCostsEvaluator.Users

  @doc """
  Returns `sub` key of the user's JWT.
  """
  @spec subject_for_token(%User{}, any) :: {:error, :reason_for_error} | {:ok, binary}
  def subject_for_token(%User{} = user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  @doc """
  Returns `AdaptableCostsEvaluator.Users.User` based on the given `sub` key.
  """
  @spec resource_from_claims(any) :: {:error, :reason_for_error} | {:ok, any}
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
