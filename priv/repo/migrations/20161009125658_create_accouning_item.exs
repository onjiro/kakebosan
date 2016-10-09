defmodule Kakebosan.Repo.Migrations.CreateAccouning.Item do
  use Ecto.Migration

  def change do
    create table(:accounting_items) do
      add :name, :string, null: false
      add :selectable, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :type_id, references(:accounting_types, on_delete: :nothing), null: false
      add :description, :string

      timestamps()
    end
    create index(:accounting_items, [:user_id])
    create index(:accounting_items, [:type_id])

  end
end
