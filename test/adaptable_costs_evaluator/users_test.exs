defmodule AdaptableCostsEvaluator.UsersTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture, OrganizationFixture}

  alias AdaptableCostsEvaluator.{Repo, Users, Organizations}

  describe "users" do
    alias AdaptableCostsEvaluator.Users.User
    alias AdaptableCostsEvaluator.Users.Credential

    setup do
      user = user_fixture()
      organization = organization_fixture()
      Organizations.create_membership(organization.id, user.id)

      %{user: user, organization: organization}
    end

    test "list_users/0 returns all users", %{user: user} do
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id", %{user: user} do
      assert Users.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email", %{user: user} do
      assert Users.get_user_by_email!(user.credential.email) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@update_user_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.middle_name == "some updated middle_name"
      assert user.credential.email == "some_updated@example.com"
      assert Bcrypt.verify_pass("87654321", user.credential.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_user_attrs)
    end

    test "update_user/2 with valid data updates the user", %{user: user} do
      assert {:ok, %User{} = user} = Users.update_user(user, @update_user_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.middle_name == "some updated middle_name"
      assert user.credential.email == "some_updated@example.com"
      assert Bcrypt.verify_pass("87654321", user.credential.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_user_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user", %{user: user} do
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Credential, user.credential.id) end
    end

    test "change_user/1 returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "list_organizations/1 returns all organizations of the user", %{user: user, organization: organization} do
      assert Users.list_organizations(user.id) == [organization]
    end

    test "has_role/3 determines whether the user has the role in the organization", %{user: user, organization: organization} do
      assert Users.has_role?(:regular, user.id, organization.id) == true
      assert Users.has_role?(:owner, user.id, organization.id) == false
    end

    test "hash_password/1 returns a hash of the given password" do
      assert is_binary(Users.hash_password("123456789")) == true
    end

    test "token_sign_in/1 returns JWT for the existing user", %{user: user} do
      token = Users.token_sign_in(user.credential.email, "12345678")

      assert {:ok, _, _} = token
    end

    test "token_sign_in/1 returns error for the non-existing user" do
      assert {:error, :unauthorized} = Users.token_sign_in("unknown@example.com", "")
    end

    test "token_sign_in/1 returns error for the incorrect password", %{user: user} do
      error = Users.token_sign_in(user.credential.email, "8654321")

      assert {:error, :unauthorized} = error
    end
  end
end
