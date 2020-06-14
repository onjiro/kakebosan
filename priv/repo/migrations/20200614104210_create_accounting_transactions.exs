defmodule Kakebosan.Repo.Migrations.CreateAccountingTransactions do
  use Ecto.Migration

  def change do
    create table(:accounting_transactions) do
      add :user_id, :integer, null: false
      add :date, :utc_datetime
      add :description, :string

      timestamps()
    end
  end
end
