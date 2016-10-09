defmodule Kakebosan.Accouning.Item do
  use Kakebosan.Web, :model

  schema "accounting_items" do
    field :name, :string
    field :description, :string
    field :selectable, :boolean, default: false
    belongs_to :user, Kakebosan.User
    belongs_to :type, Kakebosan.Accounting.Type

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :selectable])
    |> validate_required([:name])
  end
end
