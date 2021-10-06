defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :username, :string, null: false

      timestamps()
    end

    create unique_index(:organizations, [:username])
  end
end
