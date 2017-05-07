defmodule Kakebosan.Accounting.InventoryTest do
  use Kakebosan.ModelCase

  alias Kakebosan.Accounting.Inventory

  @valid_attrs %{user_id: 1, item_id: 2, amount: 123, date: Ecto.DateTime.cast!("2017-05-01T00:00:00Z")}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Inventory.changeset(%Inventory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Inventory.changeset(%Inventory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
