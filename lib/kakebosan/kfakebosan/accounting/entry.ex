defmodule Kakebosan.Accounting.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kakebosan.Accounting

  schema "accounting_entries" do
    field :side_id, :integer
    field :amount, :integer
    belongs_to :transaction, Accounting.Transaction
    belongs_to :item, Accounting.Item

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:side_id, :amount, :transaction_id, :item_id])
    |> validate_required([:side_id, :amount, :item_id])
  end
end
