defmodule Kakebosan.Repo.Migrations.CreateAccouning.Transaction do
  use Ecto.Migration

  def change do
    create table(:accounting_transactions) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :date, :datetime, null: false
      add :description, :string

      timestamps()
    end
    create index(:accounting_transactions, [:user])
    create index(:accounting_transactions, [:date])

  end
end
