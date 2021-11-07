defmodule AdaptableCostsEvaluator.ComputationsTest do
  use AdaptableCostsEvaluator.DataCase
  use AdaptableCostsEvaluator.Fixtures.{ComputationFixture, UserFixture, OrganizationFixture}

  alias AdaptableCostsEvaluator.Computations

  describe "computations" do
    alias AdaptableCostsEvaluator.Computations.Computation

    setup do
      user = user_fixture()
      organization = organization_fixture()
      computation = computation_fixture(user, %{"organization_id" => organization.id})

      %{computation: computation, user: user}
    end

    test "list_computations/1 returns desired computations", %{computation: computation, user: _} do
      assert Computations.list_computations(creator_id: computation.creator_id) == [computation]

      assert Computations.list_computations(organization_id: computation.organization_id) == [
               computation
             ]
    end

    test "get_computation!/1 returns the computation with given id", %{
      computation: computation,
      user: _
    } do
      assert Computations.get_computation!(computation.id) == computation
    end

    test "create_computation/1 with valid data creates a computation", %{
      computation: _,
      user: user
    } do
      assert {:ok, %Computation{} = computation} =
               Computations.create_computation(user, @valid_computation_attrs)

      assert computation.name == "some name"
    end

    test "create_computation/1 with invalid data returns error changeset", %{
      computation: _,
      user: user
    } do
      assert {:error, %Ecto.Changeset{}} =
               Computations.create_computation(user, @invalid_computation_attrs)
    end

    test "update_computation/2 with valid data updates the computation", %{
      computation: computation,
      user: _
    } do
      assert {:ok, %Computation{} = computation} =
               Computations.update_computation(computation, @update_computation_attrs)

      assert computation.name == "some updated name"
    end

    test "update_computation/2 with invalid data returns error changeset", %{
      computation: computation,
      user: _
    } do
      assert {:error, %Ecto.Changeset{}} =
               Computations.update_computation(computation, @invalid_computation_attrs)

      assert computation == Computations.get_computation!(computation.id)
    end

    test "delete_computation/1 deletes the computation", %{computation: computation} do
      assert {:ok, %Computation{}} = Computations.delete_computation(computation)
      assert_raise Ecto.NoResultsError, fn -> Computations.get_computation!(computation.id) end
    end

    test "change_computation/1 returns a computation changeset", %{computation: computation} do
      assert %Ecto.Changeset{} = Computations.change_computation(computation)
    end
  end
end
