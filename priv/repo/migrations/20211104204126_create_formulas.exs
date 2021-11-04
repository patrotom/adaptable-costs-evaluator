defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateFormulas do
  use Ecto.Migration

  def change do
    create table(:formulas) do
      add :name, :string, null: false
      add :label, :string, null: false
      add :definition, :text
      add :computation_id, references(:computations, on_delete: :delete_all)

      timestamps()
    end

    create index(:formulas, [:computation_id])
    create unique_index(:formulas, [:label, :computation_id])
  end
end
