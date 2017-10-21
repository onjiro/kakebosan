defmodule KakebosanWeb.Accounting.ItemTest do
  use KakebosanWeb.ModelCase

  alias KakebosanWeb.Accounting.Item

  @valid_attrs %{description: "some content", name: "some content", selectable: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
