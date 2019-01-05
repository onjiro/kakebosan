defmodule KakebosanWeb.Accounting.TransactionView do
  use Kakebosan.Web, :view

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, KakebosanWeb.Accounting.TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, KakebosanWeb.Accounting.TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      date: DateTime.to_iso8601(transaction.date),
      description: transaction.description,
      entries: render_many(transaction.entries, KakebosanWeb.Accounting.EntryView, "entry.json")}
  end
end
