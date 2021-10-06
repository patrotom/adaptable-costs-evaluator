defmodule AdaptableCostsEvaluator.Fixtures.OrganizationFixture do
  use ExUnit.CaseTemplate

  alias AdaptableCostsEvaluator.Organizations
  alias AdaptableCostsEvaluator.Organizations.Organization

  using do
    quote do
      @valid_organization_attrs %{name: "some name", username: "some_username"}
      @update_organization_attrs %{name: "some updated name", username: "some_updated_username"}
      @invalid_organization_attrs %{name: nil, username: nil}

      def organization_fixture(attrs \\ %{}) do
        {:ok, organization} =
          attrs
          |> Enum.into(@valid_organization_attrs)
          |> Organizations.create_organization()

        organization
      end

      def organization_response(%Organization{} = organization) do
        %{
          "id" => organization.id,
          "name" => organization.name,
          "username" => organization.username
        }
      end
    end
  end
end
