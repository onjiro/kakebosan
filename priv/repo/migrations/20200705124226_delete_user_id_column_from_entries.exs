defmodule Kakebosan.Repo.Migrations.DeleteUserIdColumnFromEntries do
  use Ecto.Migration

  def change do
    alter table("accounting_entries") do
      remove :user_id
    end
  end
end
