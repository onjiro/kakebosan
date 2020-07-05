defmodule KakebosanWeb.TransactionController do
  use KakebosanWeb, :controller

  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Transaction

  action_fallback KakebosanWeb.FallbackController

  def index(%{assigns: %{current_user: user}} = conn, _params) do
    transactions = Accounting.list_transactions(user)
    render(conn, "index.json", accounting_transactions: transactions)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"transaction" => transaction_params}) do
    params = transaction_params |> Map.put("user_id", user.id)

    with {:ok, %Transaction{} = transaction} <- Accounting.create_transaction(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    transaction = Accounting.get_transaction!(id)

    with :ok <- Bodyguard.permit(Accounting, :get_transaction, user, transaction) do
      render(conn, "show.json", transaction: transaction)
    end
  end

  def update(%{assigns: %{current_user: user}} = conn, %{
        "id" => id,
        "transaction" => transaction_params
      }) do
    transaction = Accounting.get_transaction!(id)

    params = transaction_params |> Map.put("user_id", user.id)

    with :ok <- Bodyguard.permit(Accounting, :update_transaction, user, transaction),
         {:ok, %Transaction{} = transaction} <-
           Accounting.update_transaction(transaction, params) do
      render(conn, "show.json", transaction: transaction)
    end
  end

  def delete(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    transaction = Accounting.get_transaction!(id)

    with :ok <- Bodyguard.permit(Accounting, :delete_transaction, user, transaction),
         {:ok, %Transaction{}} <- Accounting.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
