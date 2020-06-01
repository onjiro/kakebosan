defmodule Kakebosan.User do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  alias Kakebosan.User

  schema "users" do
    field :access_token, :string
    field :email, :string
    field :image_url, :string
    field :name, :string
    field :provider, :string
    field :uid, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:provider, :uid, :name, :image_url, :email, :access_token])
    |> validate_required([:provider, :uid, :name])
  end

  @doc """
  Ueberauthで認証した際に既存ユーザーが存在したらそれを取得、存在しなければ新規作成する
  """
  def find_or_create!(%UserFromAuth{} = auth) do
    Logger.debug("User.find_or_create! #{inspect(auth)}")

    provider =
      case auth.provider |> is_atom do
        true -> Atom.to_string(auth.provider)
        false -> auth.provider
      end

    case Kakebosan.Repo.get_by(User, provider: provider, uid: auth.uid) do
      nil ->
        changeset(%User{}, %{
          provider: provider,
          uid: auth.uid,
          name: auth.name,
          image_url: auth.avatar
        })
        |> Kakebosan.Repo.insert!()

      user ->
        user
    end
  end
end
