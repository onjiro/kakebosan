defmodule Kakebosan.ItemTest do
  use Kakebosan.DataCase
  alias Kakebosan.User
  alias Kakebosan.Accounting.Item

  describe("create_from_seeds!(%User{}) は") do
    defp build(:user) do
      %User{id: 1, provider: "dummy", uid: "dummy", name: "test user"}
    end

    test "userにseedsからAccounting.Itemを生成すること" do
      Item.create_from_seeds(build(:user) |> User.changeset(%{}) |> Kakebosan.Repo.insert!())

      user =
        User
        |> where([u], u.id == 1)
        |> Kakebosan.Repo.one!()
        |> Kakebosan.Repo.preload(:items)

      assert Enum.count(user.items) == 48
    end
  end
end
