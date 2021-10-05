defmodule AdaptableCostsEvaluator.UsersTest do
  use AdaptableCostsEvaluator.{DataCase, UserFixture}

  alias AdaptableCostsEvaluator.{Repo, Users}

  describe "users" do
    alias AdaptableCostsEvaluator.Users.User
    alias AdaptableCostsEvaluator.Users.Credential

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      user = user_fixture()
      assert Users.get_user_by_email!(user.credential.email) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.middle_name == "some middle_name"
      assert user.credential.email == "some@example.com"
      assert Bcrypt.verify_pass("12345678", user.credential.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.middle_name == "some updated middle_name"
      assert user.credential.email == "some_updated@example.com"
      assert Bcrypt.verify_pass("87654321", user.credential.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Credential, user.credential.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "hash_password/1 returns a hash of the given password" do
      assert is_binary(Users.hash_password("123456789")) == true
    end

    test "token_sign_in/1 returns JWT for the existing user" do
      user = user_fixture()
      token = Users.token_sign_in(user.credential.email, "12345678")

      assert {:ok, _, _} = token
    end

    test "token_sign_in/1 returns error for the non-existing user" do
      assert {:error, :unauthorized} = Users.token_sign_in("unknown@example.com", "")
    end

    test "token_sign_in/1 returns error for the incorrect password" do
      user = user_fixture()
      error = Users.token_sign_in(user.credential.email, "8654321")

      assert {:error, :unauthorized} = error
    end
  end
end
