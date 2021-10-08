defmodule AdaptableCostsEvaluatorWeb.UserControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase
  use AdaptableCostsEvaluator.Fixtures.UserFixture

  alias AdaptableCostsEvaluator.{Users, Guardian}

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_conns: 2]

  setup %{conn: conn} do
    user_fixture()
    |> setup_conns(conn)
  end

  describe "index" do
    test "lists all users", %{conns: conns, user: user} do
      conn = get(conns[:authd], Routes.user_path(conns[:authd], :index))
      assert json_response(conn, 200)["data"] == [user_response(user)]
    end
  end

  describe "create user" do
    test "renders user and token when data is valid", %{conns: conns, user: _user} do
      attrs =
        Map.replace!(@valid_user_attrs, :credential, %{
          @valid_user_attrs[:credential]
          | email: "new@example.com"
        })

      conn = post(conns[:plain], Routes.user_path(conns[:plain], :create), user: attrs)
      assert %{"id" => id, "token" => token} = json_response(conn, 201)["data"]
      assert {:ok, _claims} = Guardian.decode_and_verify(token)

      conn = get(conns[:authd], Routes.user_path(conns[:authd], :show, id))
      user = Users.get_user!(id)

      assert json_response(conn, 200)["data"] == user_response(user)
    end

    test "renders errors when data is invalid", %{conns: conns} do
      conn = post(conns[:plain], Routes.user_path(conns[:plain], :create), user: @invalid_user_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conns: conns, user: user} do
      conn =
        put(conns[:authd], Routes.user_path(conns[:authd], :update, user), user: @update_user_attrs)

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))
      user = Users.get_user!(user.id)

      assert json_response(conn, 200)["data"] == user_response(user)
    end

    test "renders errors when data is invalid", %{conns: conns, user: user} do
      conn =
        put(conns[:authd], Routes.user_path(conns[:authd], :update, user), user: @invalid_user_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conns: conns, user: user} do
      conn = delete(conns[:authd], Routes.user_path(conns[:authd], :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "sign in user" do
    test "renders token when credentials are valid", %{conns: conns, user: user} do
      body = %{
        data: %{
          email: user.credential.email,
          password: @valid_user_attrs[:credential][:password]
        }
      }

      conn = post(conns[:plain], Routes.user_path(conns[:plain], :sign_in), body)

      assert %{"token" => _token} = json_response(conn, 200)["data"]
    end

    test "renders unauthorized error when credentials are invalid", %{conns: conns, user: _user} do
      body = %{
        data: %{
          email: "random@email.com",
          password: "randompassword"
        }
      }

      conn = post(conns[:plain], Routes.user_path(conns[:plain], :sign_in), body)

      assert json_response(conn, 401)["errors"] == ["authorization failed"]
    end
  end
end
