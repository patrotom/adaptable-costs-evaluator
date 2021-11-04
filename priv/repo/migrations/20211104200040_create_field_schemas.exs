defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateFieldSchemas do
  use Ecto.Migration

  def change do
    create table(:field_schemas) do
      add :name, :string, null: false
      add :definition, :map, null: false

      timestamps()
    end

    create unique_index(:field_schemas, [:name])
  end
end
