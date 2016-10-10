defmodule Kakebosan.Accounting.Type do
  use Kakebosan.Web, :model

  schema "accounting_types" do
    field :name, :string
    field :deleted_at, Ecto.DateTime
    belongs_to :side, Kakebosan.Accounting.Side

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :deleted_at])
    |> validate_required([:name])
  end
end
