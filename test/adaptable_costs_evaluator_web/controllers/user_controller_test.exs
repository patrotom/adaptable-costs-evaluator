defmodule AdaptableCostsEvaluatorWeb.UserControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase
  use AdaptableCostsEvaluator.UserFixture

  alias AdaptableCostsEvaluator.{Users, Guardian}

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

    plain =
      conn
      |> put_req_header("accept", "application/json")

    authd =
      plain
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, conns: %{plain: plain, authd: authd}, user: user}
  end

  describe "index" do
    test "lists all users", %{conns: conns, user: user} do
      conn = get(conns[:authd], Routes.user_path(conns[:authd], :index))
      assert json_response(conn, 200)["data"] == [user_response(user)]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conns: conns, user: _user} do
      attrs =
        Map.replace!(@valid_attrs, :credential, %{
          @valid_attrs[:credential]
          | email: "new@example.com"
        })

      conn = post(conns[:plain], Routes.user_path(conns[:plain], :create), user: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conns[:authd], Routes.user_path(conns[:authd], :show, id))
      user = Users.get_user!(id)

      assert json_response(conn, 200)["data"] == user_response(user)
    end

    test "renders errors when data is invalid", %{conns: conns} do
      conn = post(conns[:plain], Routes.user_path(conns[:plain], :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conns: conns, user: user} do
      conn =
        put(conns[:authd], Routes.user_path(conns[:authd], :update, user), user: @update_attrs)

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))
      user = Users.get_user!(user.id)

      assert json_response(conn, 200)["data"] == user_response(user)
    end

    test "renders errors when data is invalid", %{conns: conns, user: user} do
      conn =
        put(conns[:authd], Routes.user_path(conns[:authd], :update, user), user: @invalid_attrs)

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
end
