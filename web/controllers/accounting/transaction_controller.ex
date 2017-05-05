defmodule Kakebosan.Accounting.TransactionController do
  use Kakebosan.Web, :controller

  alias Kakebosan.Accounting.Transaction
  alias Kakebosan.Accounting.Entry
  alias Kakebosan.Accounting.Item
  plug :load_and_authorize_resource, model: Transaction, preload: [entries: [:item]]
  plug :scrub_params, "transaction" when action in [:create, :update]

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
    user = get_session(conn, :current_user)

    transaction = Transaction.changeset(%Transaction{}, Map.merge(transaction_params, %{"user_id" => user.id}))
    entries = for e <- transaction_params["entries"] || [] do
      item = Repo.get!(Item, e["item"]["id"])
      Entry.changeset(%Entry{}, Map.merge(e, %{"user_id" => user.id, "item_id" => item.id}))
    end
    changeset = Ecto.Changeset.put_assoc(transaction, :entries, entries)

    case Repo.insert(changeset) do
      {:ok, transaction} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", transaction_path(conn, :show, transaction))
        |> render("show.json", transaction: Repo.preload(transaction, entries: [:side, :item]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Kakebosan.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}) do
    case conn.assigns.transaction do
      nil ->
        conn
        |> put_status(404)
        |> render(Kakebosan.ErrorView, "404.json")
      _ ->
        render(conn, "show.json", transaction: conn.assigns.transaction)
    end
  end

  def update(conn, %{"id" => _id, "transaction" => transaction_params}) do
    user = get_session(conn, :current_user)

    changeset =
      conn.assigns.transaction
      |> Transaction.changeset(transaction_params)
      |> Ecto.Changeset.put_assoc(:entries, for e <- transaction_params["entries"] || [] do
                                               item = Repo.get!(Item, e["item"]["id"])
                                               Entry.changeset(%Entry{}, Map.merge(e, %{"user_id" => user.id, "item_id" => item.id}))
                                             end)

    case Repo.update(changeset) do
      {:ok, transaction} ->
        render(conn, "show.json", transaction: Repo.preload(transaction, entries: [:side, :item]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Kakebosan.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    Repo.delete!(conn.assigns.transaction)
    send_resp(conn, :no_content, "")
  end
end
