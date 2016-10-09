defmodule Kakebosan.Repo.Migrations.CreateAccouning.Side do
  use Ecto.Migration

  def change do
    create table(:accounting_sides) do
      add :name, :string, null: false
      add :deleted_at, :datetime

      timestamps()
    end

  end
end
