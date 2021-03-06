defmodule Kakebosan.Accounting.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Kakebosan.User
  alias Kakebosan.Accounting

  @behaviour Bodyguard.Schema

  schema "accounting_items" do
    belongs_to :user, Kakebosan.User

    field :name, :string
    field :description, :string
    field :type_id, :integer
    field :selectable, :boolean, default: false

    timestamps()
  end

  @doc """
  ユーザーがアクセス可能な勘定科目以外をフィルタで除外する
  @see https://hexdocs.pm/bodyguard/Bodyguard.html#scope/4
  """
  def scope(query, %User{id: user_id}, _) do
    query |> where([query], query.user_id == ^user_id)
  end

  def scope(_, _, _), do: raise("No user specified")

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :type_id, :description, :selectable, :user_id])
    |> validate_required([:name, :type_id, :user_id])
  end

  def create_from_seeds(%User{id: user_id}) do
    for item <- seeds() do
      %Accounting.Item{}
      |> changeset(item |> Map.put(:user_id, user_id))
      |> Kakebosan.Repo.insert!()
    end
  end

  defp seeds() do
    for {type, items} <- Application.get_env(:kakebosan, :item_seeds, []) do
      for item <- items do
        item
        |> Map.put(
          :type_id,
          case type do
            :assets -> Accounting.Type.asset().id
            :expenses -> Accounting.Type.expense().id
            :liabilities -> Accounting.Type.liability().id
            :net_assets -> Accounting.Type.net_asset().id
            :revenues -> Accounting.Type.revenue().id
          end
        )
      end
    end
    |> List.flatten()
  end
end
