defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateComputations do
  use Ecto.Migration

  def change do
    create table(:computations) do
      add :name, :string, null: false
      add :creator_id, references(:users, on_delete: :delete_all), null: false
      add :organization_id, references(:organizations, on_delete: :nilify_all)

      timestamps()
    end

    create index(:computations, [:creator_id])
    create index(:computations, [:organization_id])
  end
end
