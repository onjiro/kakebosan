defmodule Kakebosan.Repo.Migrations.CreateAccountingItems do
  use Ecto.Migration

  def change do
    create table(:accounting_items) do
      add :name, :string
      add :type_id, :integer
      add :description, :string
      add :selectable, :boolean, default: false, null: false
      add :user_id, :integer

      timestamps()
    end

  end
end
