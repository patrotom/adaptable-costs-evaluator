defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateEvaluators do
  use Ecto.Migration

  def change do
    create table(:evaluators) do
      add :name, :string, null: false
      add :description, :text
      add :module, :string, null: false

      timestamps()
    end

    create unique_index(:evaluators, [:name])

    alter table(:formulas) do
      add :evaluator_id, references(:evaluators, on_delete: :nilify_all)
    end
  end
end
