defmodule Kakebosan.Accounting.Inventory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kakebosan.User
  alias Kakebosan.Accounting

  schema "accounting_inventories" do
    field :amount, :integer
    field :date, :utc_datetime
    belongs_to :user, User
    belongs_to :item, Accounting.Item
    belongs_to :clearance_transaction, Accounting.Transaction

    timestamps()
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:date, :amount, :user_id, :item_id, :clearance_transaction_id])
    |> validate_required([:date, :amount, :user_id, :item_id])
  end
end
