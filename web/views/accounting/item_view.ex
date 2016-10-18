defmodule Kakebosan.Accounting.ItemView do
  use Kakebosan.Web, :view

  def render("index.json", %{accounting_items: accounting_items}) do
    %{data: render_many(accounting_items, Kakebosan.Accounting.ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, Kakebosan.Accounting.ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      name: item.name}
  end
end
