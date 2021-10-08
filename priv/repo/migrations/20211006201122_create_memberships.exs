defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:memberships, [:user_id])
    create index(:memberships, [:organization_id])
    create unique_index(:memberships, [:user_id, :organization_id])
  end
end
