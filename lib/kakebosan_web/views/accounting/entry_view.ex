defmodule KakebosanWeb.Accounting.EntryView do
  use Kakebosan.Web, :view

  def render("index.json", %{entrys: entrys}) do
    %{data: render_many(entrys, KakebosanWeb.Accounting.EntryView, "entry.json")}
  end

  def render("show.json", %{entry: entry}) do
    %{data: render_one(entry, KakebosanWeb.Accounting.EntryView, "entry.json")}
  end

  def render("entry.json", %{entry: entry}) do
    %{id: entry.id,
      amount: entry.amount,
      side_id: entry.side_id,
      item: render_one(entry.item, KakebosanWeb.Accounting.ItemView, "item.json")}
  end
end
