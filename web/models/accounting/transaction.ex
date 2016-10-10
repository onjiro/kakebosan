defmodule Kakebosan.Accounting.Transaction do
  use Kakebosan.Web, :model

  schema "accounting_transactions" do
    field :date, Ecto.DateTime
    field :description, :string
    belongs_to :user, Kakebosan.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :description])
    |> validate_required([:date])
  end
end
