defmodule KakebosanWeb.InventorySettingTest do
  use KakebosanWeb.ModelCase

  alias KakebosanWeb.InventorySetting

  @valid_attrs %{}
  @invalid_attrs %{user_id: "hoge"}

  test "changeset with valid attributes" do
    changeset = InventorySetting.changeset(%InventorySetting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = InventorySetting.changeset(%InventorySetting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
