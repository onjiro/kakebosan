defmodule Kakebosan.Accounting.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounting_entries" do
    field :side_id, :integer
    field :amount, :integer
    belongs_to :user, KakebosanWeb.User
    belongs_to :transaction, KakebosanWeb.Accounting.Transaction
    belongs_to :item, KakebosanWeb.Accounting.Item

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:side_id, :amount, :user_id, :transaction_id, :item_id])
    |> validate_required([:side_id, :amount, :user_id, :item_id])
  end
end
