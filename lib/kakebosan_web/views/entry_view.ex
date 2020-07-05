defmodule KakebosanWeb.EntryView do
  use KakebosanWeb, :view
  alias KakebosanWeb.EntryView

  def render("index.json", %{accounting_entries: accounting_entries}) do
    %{data: render_many(accounting_entries, EntryView, "entry.json")}
  end

  def render("show.json", %{entry: entry}) do
    %{data: render_one(entry, EntryView, "entry.json")}
  end

  def render("entry.json", %{entry: entry}) do
    %{
      id: entry.id,
      side_id: entry.side_id,
      item_id: entry.item_id,
      amount: entry.amount
    }
  end
end
