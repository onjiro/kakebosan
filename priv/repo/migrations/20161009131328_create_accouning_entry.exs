defmodule Kakebosan.Repo.Migrations.CreateAccouning.Entry do
  use Ecto.Migration

  def change do
    create table(:accounting_entries) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :transaction_id, references(:accounting_transactions, on_delete: :nothing), null: false
      add :side_id, references(:accounting_sides, on_delete: :nothing), null: false
      add :item_id, references(:accounting_items, on_delete: :nothing), null: false
      add :amount, :integer, null: false

      timestamps()
    end
    create index(:accounting_entries, [:user_id, :item_id, :side_id])
    create index(:accounting_entries, [:transaction_id])
    create index(:accounting_entries, [:side_id])
    create index(:accounting_entries, [:item_id])

  end
end
