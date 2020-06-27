defmodule Kakebosan.Accounting.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @behaviour Bodyguard.Schema

  alias Kakebosan.User

  schema "accounting_transactions" do
    field :date, :utc_datetime
    field :description, :string
    field :user_id, :integer

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
    |> validate_required([:user_id, :date])
  end
end
