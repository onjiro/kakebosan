defmodule KakebosanWeb.TransactionView do
  use KakebosanWeb, :view
  alias KakebosanWeb.TransactionView

  def render("index.json", %{accounting_transactions: accounting_transactions}) do
    %{data: render_many(accounting_transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      user_id: transaction.user_id,
      date: transaction.date,
      description: transaction.description
    }
  end
end
