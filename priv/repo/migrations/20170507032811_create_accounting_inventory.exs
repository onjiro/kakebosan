defmodule Kakebosan.Repo.Migrations.CreateAccounting.Inventory do
  use Ecto.Migration

  def change do
    create table(:accounting_inventories) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :item_id, references(:accounting_items, on_delete: :nothing), null: false
      add :date, :utc_datetime, null: false
      add :amount, :integer, null: false
      add :clearance_transaction_id, references(:accounting_transactions, on_delete: :delete_all)

      timestamps()
    end
    create index(:accounting_inventories, [:user_id, :item_id, :date])
    create index(:accounting_inventories, [:item_id])
    create index(:accounting_inventories, [:clearance_transaction_id])
  end
end
