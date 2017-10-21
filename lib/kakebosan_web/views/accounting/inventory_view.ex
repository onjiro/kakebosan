defmodule KakebosanWeb.Accounting.InventoryView do
  use Kakebosan.Web, :view

  def render("index.json", %{accounting_inventories: accounting_inventories}) do
    %{data: render_many(accounting_inventories, KakebosanWeb.Accounting.InventoryView, "inventory.json")}
  end

  def render("show.json", %{inventory: inventory}) do
    %{data: render_one(inventory, KakebosanWeb.Accounting.InventoryView, "inventory.json")}
  end

  def render("inventory.json", %{inventory: inventory}) do
    %{id: inventory.id,
      date: inventory.date,
      item: render_one(inventory.item, KakebosanWeb.Accounting.ItemView, "item.json"),
      amount: inventory.amount,
      clearance_transaction: render_one(inventory.clearance_transaction, KakebosanWeb.Accounting.TransactionView, "transaction.json")}
  end
end
