defmodule KakebosanWeb.Accounting.ItemView do
  use KakebosanWeb, :view
  alias KakebosanWeb.Accounting.ItemView

  def render("index.json", %{accounting_items: accounting_items}) do
    %{data: render_many(accounting_items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id, name: item.name}
  end
end
