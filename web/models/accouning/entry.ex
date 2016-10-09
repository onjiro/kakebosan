defmodule Kakebosan.Accouning.Entry do
  use Kakebosan.Web, :model

  schema "accounting_entries" do
    field :amount, :integer
    belongs_to :user, Kakebosan.User
    belongs_to :transaction, Kakebosan.Transaction
    belongs_to :side, Kakebosan.Side
    belongs_to :item, Kakebosan.Item

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amount])
    |> validate_required([:amount])
  end
end
