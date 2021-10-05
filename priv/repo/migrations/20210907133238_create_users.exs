defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, size: 50, null: false
      add :middle_name, :string, size: 50
      add :last_name, :string, size: 50, null: false

      timestamps()
    end

  end
end
