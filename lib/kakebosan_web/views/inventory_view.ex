defmodule KakebosanWeb.InventoryView do
  use KakebosanWeb, :view
  alias KakebosanWeb.InventoryView

  def render("index.json", %{inventories: inventories}) do
    %{data: render_many(inventories, InventoryView, "inventory.json")}
  end

  def render("show.json", %{inventory: inventory}) do
    %{data: render_one(inventory, InventoryView, "inventory.json")}
  end

  def render("inventory.json", %{inventory: inventory}) do
    %{id: inventory.id, date: inventory.date, amount: inventory.amount}
  end
end
