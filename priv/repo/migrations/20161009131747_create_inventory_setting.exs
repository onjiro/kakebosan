defmodule Kakebosan.Repo.Migrations.CreateInventorySetting do
  use Ecto.Migration

  def change do
    create table(:inventory_setting) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :debit_item_id, references(:accounting_items, on_delete: :nothing), null: false
      add :credit_item_id, references(:accounting_items, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:inventory_setting, [:user_id])
    create index(:inventory_setting, [:debit_item_id])
    create index(:inventory_setting, [:credit_item_id])

  end
end
