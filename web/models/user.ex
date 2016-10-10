defmodule Kakebosan.User do
  use Kakebosan.Web, :model
  require Logger

  alias Kakebosan.User

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

  @doc """
  ueberauth 由でのユーザー作成
  """
  def create_with_ueberauth(%{provider: :identity, info: info, uid: uid} = auth) do
    Logger.info("create_with_ueberauth #{inspect auth}")
    changeset(%User{}, %{ provider: "identity", uid: uid, name: info.nickname, access_token: "",
                          image_url: info.image || "", email: info.email || ""})
    |> create_new_user
  end
  def create_with_ueberauth(%{provider: :twitter, info: info, uid: uid} = auth) do
    Logger.info("create_with_ueberauth #{inspect auth}")
    changeset(%User{}, %{ provider: "twitter", uid: uid, name: info.name, access_token: "",
                          image_url: info.image || "", email: info.email || ""})
    |> create_new_user
  end
  def create_with_ueberauth(%{provider: provider, info: info, uid: uid} = auth) do
    Logger.info("create_with_ueberauth #{inspect auth}")
    changeset(%User{}, %{ provider: Atom.to_string(provider), uid: uid, name: info.name, access_token: "",
                          image_url: info.image || "", email: info.email} || "")
    |> create_new_user
  end

  defp create_new_user(changeset) do
    case changeset.valid? && Kakebosan.Repo.insert(changeset) do
      {:ok, user} ->
        Kakebosan.Accounting.Item.create_initial_items(user)
        user
      false ->
        Logger.warn("Validation error! #{inspect changeset.errors}")
        nil
    end
  end

end
