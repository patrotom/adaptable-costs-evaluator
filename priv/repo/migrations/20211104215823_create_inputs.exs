defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateInputs do
  use Ecto.Migration

  def change do
    create table(:inputs) do
      add :name, :string, null: false
      add :label, :string, null: false
      add :last_value, :map
      add :computation_id, references(:computations, on_delete: :delete_all), null: false
      add :field_schema_id, references(:field_schemas, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:inputs, [:computation_id])
    create index(:inputs, [:field_schema_id])
    create unique_index(:inputs, [:label, :computation_id])
  end
end
