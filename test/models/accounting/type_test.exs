defmodule KakebosanWeb.Accounting.TypeTest do
  use KakebosanWeb.ModelCase

  alias KakebosanWeb.Accounting.Type

  @valid_attrs %{deleted_at: ~N[2010-04-17 14:00:00], name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Type.changeset(%Type{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Type.changeset(%Type{}, @invalid_attrs)
    refute changeset.valid?
  end
end
