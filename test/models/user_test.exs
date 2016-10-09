defmodule Kakebosan.UserTest do
  use Kakebosan.ModelCase

  alias Kakebosan.User

  @valid_attrs %{access_token: "some content", email: "some content", image_url: "some content", name: "some content", provider: "some content", uid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
