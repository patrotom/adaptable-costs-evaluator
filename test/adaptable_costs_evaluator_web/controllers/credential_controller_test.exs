defmodule AdaptableCostsEvaluatorWeb.CredentialControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase

  alias AdaptableCostsEvaluator.Users
  alias AdaptableCostsEvaluator.Users.Credential

  @create_attrs %{
    email: "some email",
    password: "some password"
  }
  @update_attrs %{
    email: "some updated email",
    password: "some updated password"
  }
  @invalid_attrs %{email: nil, password: nil}

  def fixture(:credential) do
    {:ok, credential} = Users.create_credential(@create_attrs)
    credential
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all credentials", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create credential" do
    test "renders credential when data is valid", %{conn: conn} do
      conn = post(conn, Routes.credential_path(conn, :create), credential: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.credential_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
               "password" => "some password"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.credential_path(conn, :create), credential: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update credential" do
    setup [:create_credential]

    test "renders credential when data is valid", %{conn: conn, credential: %Credential{id: id} = credential} do
      conn = put(conn, Routes.credential_path(conn, :update, credential), credential: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.credential_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
               "password" => "some updated password"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, credential: credential} do
      conn = put(conn, Routes.credential_path(conn, :update, credential), credential: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete credential" do
    setup [:create_credential]

    test "deletes chosen credential", %{conn: conn, credential: credential} do
      conn = delete(conn, Routes.credential_path(conn, :delete, credential))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.credential_path(conn, :show, credential))
      end
    end
  end

  defp create_credential(_) do
    credential = fixture(:credential)
    %{credential: credential}
  end
end
