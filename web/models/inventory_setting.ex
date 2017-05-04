defmodule Kakebosan.InventorySetting do
  use Kakebosan.Web, :model

  schema "inventory_setting" do
    belongs_to :user, Kakebosan.User
    belongs_to :debit_item, Kakebosan.DebitItem
    belongs_to :credit_item, Kakebosan.CreditItem

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :debit_item_id, :credit_item_id])
    |> validate_required([])
  end
end
