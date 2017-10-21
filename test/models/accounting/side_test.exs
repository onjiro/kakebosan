defmodule KakebosanWeb.Accounting.SideTest do
  use KakebosanWeb.ModelCase

  alias KakebosanWeb.Accounting.Side

  @valid_attrs %{deleted_at: ~N[2010-04-17 14:00:00], name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Side.changeset(%Side{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Side.changeset(%Side{}, @invalid_attrs)
    refute changeset.valid?
  end
end
