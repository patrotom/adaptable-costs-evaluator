defmodule AdaptableCostsEvaluator.Policies.FieldSchemas.FieldSchemaPolicyTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.UserFixture

  import AdaptableCostsEvaluator.Policies.FieldSchemas.FieldSchemaPolicy

  alias AdaptableCostsEvaluator.Users

  setup do
    %{user: user_fixture()}
  end

  describe "authorize/3 with read and list actions" do
    test "authorizes all users", %{user: user} do
      Enum.each([:read, :list], fn action ->
        assert authorize(action, user, nil) == true
      end)
    end
  end

  describe "authorize/3 with rest of the actions" do
    test "authorizes admin", %{user: user} do
      {:ok, user} = Users.update_user(user, %{admin: true})
      assert authorize(:random, user, nil) == true
    end

    test "does not authorize a user who is not the admin", %{user: user} do
      assert authorize(:random, user, nil) == false
    end
  end
end
