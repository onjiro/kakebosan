defmodule KakebosanWeb.TransactionController do
  use KakebosanWeb, :controller

  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Transaction

  action_fallback KakebosanWeb.FallbackController

  def index(conn, _params) do
    accounting_transactions = Accounting.list_accounting_transactions()
    render(conn, "index.json", accounting_transactions: accounting_transactions)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Accounting.create_transaction(transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Accounting.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Accounting.get_transaction!(id)

    with {:ok, %Transaction{} = transaction} <- Accounting.update_transaction(transaction, transaction_params) do
      render(conn, "show.json", transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Accounting.get_transaction!(id)

    with {:ok, %Transaction{}} <- Accounting.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
