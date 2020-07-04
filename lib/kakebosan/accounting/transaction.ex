defmodule Kakebosan.Accounting.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @behaviour Bodyguard.Schema

  alias Kakebosan.User
  alias Kakebosan.Accounting

  schema "accounting_transactions" do
    field :date, :utc_datetime
    field :description, :string
    belongs_to :user, User
    has_many :entries, Accounting.Entry, on_replace: :delete, on_delete: :delete_all

    timestamps()
  end

  def scope(query, %User{id: user_id}, _) do
    query |> where([query], query.user_id == ^user_id)
  end

  def scope(_, _, _), do: raise("No user specified")

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :date, :description])
    |> cast_assoc(:entries, with: &Accounting.Entry.changeset/2)
    |> validate_required([:user_id, :date])
  end
end
