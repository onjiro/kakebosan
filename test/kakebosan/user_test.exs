defmodule Kakebosan.UserTest do
  use Kakebosan.DataCase
  alias Kakebosan.User

  describe("find_or_create!(%Ueberauth.Auth{}) は") do
    defp build(:auth) do
      %UserFromAuth{
        provider: :test,
        uid: "1",
        name: "test user",
        avatar: "image url"
      }
    end

    test "ユーザーが作成済みではない場合、ユーザーを作成して返すこと" do
      user = User.find_or_create!(build(:auth))

      assert user.id != nil
      assert user.provider == "test"
      assert user.uid == "1"
      assert user.name == "test user"
      assert user.image_url == "image url"
    end

    test "ユーザーが作成済みの場合、既存のユーザーを返すこと" do
      User.changeset(%User{}, %{
        provider: "test",
        uid: "1",
        name: "existed user"
      })
      |> Kakebosan.Repo.insert!()

      user = User.find_or_create!(build(:auth))

      assert user.id != nil
      assert user.provider == "test"
      assert user.uid == "1"
      assert user.name == "existed user"
    end
  end
end
