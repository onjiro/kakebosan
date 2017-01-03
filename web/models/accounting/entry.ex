defmodule Kakebosan.Accounting.Entry do
  use Kakebosan.Web, :model

  schema "accounting_entries" do
    field :amount, :integer
    belongs_to :user, Kakebosan.User
    belongs_to :transaction, Kakebosan.Accounting.Transaction
    belongs_to :side, Kakebosan.Accounting.Side
    belongs_to :item, Kakebosan.Accounting.Item

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
