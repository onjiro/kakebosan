defmodule Kakebosan.Accounting.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounting_entries" do
    field :amount, :integer

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
