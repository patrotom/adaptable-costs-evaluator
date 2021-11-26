defmodule AdaptableCostsEvaluatorWeb.ComputationControllerTest do
  use AdaptableCostsEvaluatorWeb.ConnCase
  use AdaptableCostsEvaluator.Fixtures.{UserFixture, OrganizationFixture, ComputationFixture}

  alias AdaptableCostsEvaluator.{Computations, Organizations}

  import AdaptableCostsEvaluator.Helpers.ConnHelper, only: [setup_authd_conn: 2]

  setup %{conn: conn} do
    user = user_fixture(admin: true)
    organization = organization_fixture()
    Organizations.create_membership(organization.id, user.id)
    computation = computation_fixture(user, %{"organization_id" => organization.id})
    {:ok, conn: conn} = setup_authd_conn(user, conn)

    %{conn: conn, user: user, organization: organization, computation: computation}
  end

  describe "index" do
    test "lists all computations of user", context do
      conn =
        get(
          context[:conn],
          Routes.user_computation_path(context[:conn], :index, context[:user].id)
        )

      assert json_response(conn, 200)["data"] == [computation_response(context[:computation])]
    end

    test "lists all computations in organization", context do
      conn =
        get(
          context[:conn],
          Routes.organization_computation_path(context[:conn], :organization_index, context[:organization].id)
        )

      assert json_response(conn, 200)["data"] == [computation_response(context[:computation])]
    end
  end

  describe "create computation" do
    test "renders computation when data is valid", context do
      conn =
        post(context[:conn], Routes.computation_path(context[:conn], :create),
          computation: @valid_computation_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.computation_path(conn, :show, id))
      computation = Computations.get_computation!(id)

      assert json_response(conn, 200)["data"] == computation_response(computation)
    end

    test "renders errors when data is invalid", context do
      conn =
        post(context[:conn], Routes.computation_path(context[:conn], :create),
          computation: @invalid_computation_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "add computation to organization" do
    test "renders no content", context do
      conn =
        post(
          context[:conn],
          Routes.computation_path(
            context[:conn],
            :organization_create,
            context[:organization].id,
            context[:computation].id
          )
        )

      assert response(conn, 204)
    end
  end

  describe "update computation" do
    test "renders computation when data is valid", context do
      conn =
        patch(
          context[:conn],
          Routes.computation_path(context[:conn], :update, context[:computation]),
          computation: @update_computation_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.computation_path(conn, :show, id))
      computation = Computations.get_computation!(id)

      assert json_response(conn, 200)["data"] == computation_response(computation)
    end

    test "renders errors when data is invalid", context do
      conn =
        put(
          context[:conn],
          Routes.computation_path(context[:conn], :update, context[:computation]),
          computation: @invalid_computation_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete computation" do
    test "deletes chosen computation", context do
      conn =
        delete(
          context[:conn],
          Routes.computation_path(context[:conn], :delete, context[:computation])
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.computation_path(conn, :show, context[:computation]))
      end
    end

    test "deletes computation from the organization", context do
      conn =
        delete(
          context[:conn],
          Routes.computation_path(
            context[:conn],
            :organization_delete,
            context[:organization].id,
            context[:computation].id
          )
        )

      assert response(conn, 204)

      computation = Computations.get_computation!(context[:computation].id)

      assert computation.organization_id == nil
    end
  end
end
