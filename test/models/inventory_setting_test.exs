defmodule Kakebosan.InventorySettingTest do
  use Kakebosan.ModelCase

  alias Kakebosan.InventorySetting

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = InventorySetting.changeset(%InventorySetting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = InventorySetting.changeset(%InventorySetting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
