defmodule AdaptableCostsEvaluator.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :type, :string, null: false
      add :membership_id, references(:memberships, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:roles, [:membership_id])
    create unique_index(:roles, [:type, :membership_id])
  end
end
