defmodule Kakebosan.Accounting.ItemView do
  use Kakebosan.Web, :view

  def render("index.json", %{items: items}) do
    %{data: render_many(items, Kakebosan.Accounting.ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, Kakebosan.Accounting.ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      name: item.name,
      selectable: item.selectable,
      type_id: item.type_id,
      description: item.description}
  end
end
