defmodule Kakebosan.Accounting.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounting_transactions" do
    field :date, :utc_datetime
    field :description, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :date, :description])
    |> validate_required([:user_id, :date, :description])
  end
end
