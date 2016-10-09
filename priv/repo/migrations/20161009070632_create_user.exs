defmodule Kakebosan.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :name, :string
      add :image_url, :string
      add :email, :string
      add :access_token, :string

      timestamps()
    end

  end
end
