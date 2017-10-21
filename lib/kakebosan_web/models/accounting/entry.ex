defmodule KakebosanWeb.Accounting.Entry do
  use Kakebosan.Web, :model

  schema "accounting_entries" do
    field :amount, :integer
    belongs_to :user, KakebosanWeb.User
    belongs_to :transaction, KakebosanWeb.Accounting.Transaction
    belongs_to :side, KakebosanWeb.Accounting.Side
    belongs_to :item, KakebosanWeb.Accounting.Item

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :amount, :side_id, :item_id, :transaction_id])
    |> validate_required([:amount])
  end
end
