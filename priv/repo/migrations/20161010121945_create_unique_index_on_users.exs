defmodule Kakebosan.Repo.Migrations.CreateUniqueIndexOnUsers do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:provider, :uid])
  end
end
