defmodule AdaptableCostsEvaluator.ComputationsTest do
  use AdaptableCostsEvaluator.DataCase

  alias AdaptableCostsEvaluator.Computations

  describe "computations" do
    alias AdaptableCostsEvaluator.Computations.Computation

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def computation_fixture(attrs \\ %{}) do
      {:ok, computation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Computations.create_computation()

      computation
    end

    test "list_computations/0 returns all computations" do
      computation = computation_fixture()
      assert Computations.list_computations() == [computation]
    end

    test "get_computation!/1 returns the computation with given id" do
      computation = computation_fixture()
      assert Computations.get_computation!(computation.id) == computation
    end

    test "create_computation/1 with valid data creates a computation" do
      assert {:ok, %Computation{} = computation} = Computations.create_computation(@valid_attrs)
      assert computation.name == "some name"
    end

    test "create_computation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Computations.create_computation(@invalid_attrs)
    end

    test "update_computation/2 with valid data updates the computation" do
      computation = computation_fixture()
      assert {:ok, %Computation{} = computation} = Computations.update_computation(computation, @update_attrs)
      assert computation.name == "some updated name"
    end

    test "update_computation/2 with invalid data returns error changeset" do
      computation = computation_fixture()
      assert {:error, %Ecto.Changeset{}} = Computations.update_computation(computation, @invalid_attrs)
      assert computation == Computations.get_computation!(computation.id)
    end

    test "delete_computation/1 deletes the computation" do
      computation = computation_fixture()
      assert {:ok, %Computation{}} = Computations.delete_computation(computation)
      assert_raise Ecto.NoResultsError, fn -> Computations.get_computation!(computation.id) end
    end

    test "change_computation/1 returns a computation changeset" do
      computation = computation_fixture()
      assert %Ecto.Changeset{} = Computations.change_computation(computation)
    end
  end
end
