defmodule Kakebosan.Accounting.Inventory do
  use Kakebosan.Web, :model

  schema "accounting_inventories" do
    field :date, Ecto.DateTime
    field :amount, :integer
    belongs_to :user, Kakebosan.User
    belongs_to :item, Kakebosan.Accounting.Item
    belongs_to :clearance_transaction, Kakebosan.Accounting.Transaction

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :amount, :user_id, :item_id, :clearance_transaction_id])
    |> validate_required([:date, :amount])
  end
end
