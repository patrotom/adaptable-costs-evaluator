defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateOutputs do
  use Ecto.Migration

  def change do
    create table(:outputs) do
      add :name, :string, null: false
      add :label, :string, null: false
      add :last_value, :map
      add :computation_id, references(:computations, on_delete: :delete_all), null: false
      add :field_schema_id, references(:field_schemas, on_delete: :delete_all), null: false
      add :formula_id, references(:formulas, on_delete: :nilify_all)

      timestamps()
    end

    create index(:outputs, [:computation_id])
    create index(:outputs, [:field_schema_id])
    create index(:outputs, [:formula_id])
    create unique_index(:outputs, [:label, :computation_id])
  end
end
