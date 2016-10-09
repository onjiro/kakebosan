defmodule Kakebosan.Repo.Migrations.CreateAccouning.Type do
  use Ecto.Migration

  def change do
    create table(:accounting_types) do
      add :name, :string, null: false
      add :side_id, references(:accounting_sides, on_delete: :nothing), null: false
      add :deleted_at, :datetime

      timestamps()
    end
    create index(:accounting_types, [:side_id])

  end
end
