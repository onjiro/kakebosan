defmodule Kakebosan.User do
  use Kakebosan.Web, :model

  schema "users" do
    field :provider, :string
    field :uid, :string
    field :name, :string
    field :image_url, :string
    field :email, :string
    field :access_token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:provider, :uid, :name, :image_url, :email, :access_token])
    |> validate_required([:provider, :uid, :name])
  end
end
