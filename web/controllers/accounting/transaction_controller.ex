defmodule Kakebosan.Accounting.TransactionController do
  use Kakebosan.Web, :controller

  alias Kakebosan.Accounting.Transaction
  plug :load_and_authorize_resource, model: Transaction
  plug :scrub_params, "accounting_transaction" when action in [:create, :update]

  def index(conn, _params) do
    user = get_session(conn, :current_user)
    transactions = Repo.all(
      from t in Transaction,
      join: e in assoc(t, :entries),
      join: i in assoc(e, :item),
      where: t.user_id == ^user.id,
      order_by: [t.date, t.id],
      preload: [entries: {e, item: i}]
    )
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    changeset = Transaction.changeset(%Transaction{}, transaction_params)

    case Repo.insert(changeset) do
      {:ok, transaction} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", transaction_path(conn, :show, transaction))
        |> render("show.json", transaction: transaction)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Kakebosan.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", transaction: conn.assigns.transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = conn.assigns.transaction
    changeset = Transaction.changeset(transaction, transaction_params)

    case Repo.update(changeset) do
      {:ok, transaction} ->
        render(conn, "show.json", transaction: transaction)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Kakebosan.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.delete!(conn.assigns.transaction)
    send_resp(conn, :no_content, "")
  end
end
