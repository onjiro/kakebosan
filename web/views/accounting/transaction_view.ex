defmodule Kakebosan.Accounting.TransactionView do
  use Kakebosan.Web, :view

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, Kakebosan.Accounting.TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, Kakebosan.Accounting.TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      date: transaction.date,
      description: transaction.description,
      entries: render_many(transaction.entries, Kakebosan.Accounting.EntryView, "entry.json")}
  end
end
