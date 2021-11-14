defmodule AdaptableCostsEvaluator.Fixtures.UserFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.User

  using do
    quote do
      @valid_user_attrs %{
        first_name: "some first_name",
        last_name: "some last_name",
        middle_name: "some middle_name",
        credential: %{
          email: "some@example.com",
          password: "12345678"
        },
        admin: false
      }
      @update_user_attrs %{
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        middle_name: "some updated middle_name",
        credential: %{
          email: "some_updated@example.com",
          password: "87654321"
        }
      }
      @invalid_user_attrs %{
        first_name: nil,
        last_name: nil,
        middle_name: nil,
        credential: %{
          email: "invalid",
          password: "12"
        }
      }

      def user_fixture(attrs \\ %{}) do
        {:ok, user} =
          attrs
          |> Enum.into(@valid_user_attrs)
          |> Users.create_user()

        Map.replace(user, :credential, %{user.credential | password: nil})
      end

      def user_response(%User{} = user) do
        %{
          "id" => user.id,
          "first_name" => user.first_name,
          "middle_name" => user.middle_name,
          "last_name" => user.last_name,
          "email" => user.credential.email
        }
      end
    end
  end
end
