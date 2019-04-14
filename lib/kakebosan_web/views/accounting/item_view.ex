defmodule KakebosanWeb.Accounting.ItemView do
  use Kakebosan.Web, :view

  def render("index.json", %{items: items}) do
    %{data: render_many(items, KakebosanWeb.Accounting.ItemView, "item.json")}
  end

  def render("summaries.json", %{items: items}) do
    %{data: render_many(items, KakebosanWeb.Accounting.ItemView, "summary.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, KakebosanWeb.Accounting.ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      name: item.name,
      selectable: item.selectable,
      type_id: item.type_id,
      description: item.description,
      type: case Ecto.assoc_loaded?(item.type) do
              true -> render_one(item.type, KakebosanWeb.Accounting.TypeView, "type.json")
              false -> nil
            end
    }
  end

  def render("summary.json", %{item: summary = %{item: item}}) do
    %{id: item.id,
      name: item.name,
      selectable: item.selectable,
      type_id: item.type_id,
      description: item.description,
      debit_amount: summary.debit_amount,
      credit_amount: summary.credit_amount,
      amount_grow: summary.amount_grow,
      type: case Ecto.assoc_loaded?(item.type) do
              true -> render_one(item.type, KakebosanWeb.Accounting.TypeView, "type.json")
              false -> nil
            end
    }
  end
end
