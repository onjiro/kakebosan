defmodule KakebosanWeb.Accounting.InventoryController do
  use Kakebosan.Web, :controller

  alias KakebosanWeb.Accounting.Item
  alias KakebosanWeb.Accounting.Inventory
  plug :load_and_authorize_resource, model: Inventory, preload: [:item, clearance_transaction: [entries: [:item, :side]]], only: [:show, :update, :delete]
  plug :scrub_params, "inventory" when action in [:create, :update]

  def index(conn, _params) do
    accounting_inventories = Repo.all(Inventory)
    |> Repo.preload(:item)
    |> Repo.preload(:clearance_transaction)
    render(conn, "index.json", accounting_inventories: accounting_inventories)
  end

  # transactionを集計して現在の値を出力する
  def current(conn, _params) do
    user = get_session(conn, :current_user)
    case DateTime.from_iso8601 "#{Date.utc_today |> Date.to_iso8601}T00:00:00Z" do
      {:ok, today, _offset} ->
        inventories = Item
        |> where(user_id: ^user.id)
        |> Item.inventories(today)
        |> Repo.all()
        |> Repo.preload(:item)
        |> Repo.preload(:clearance_transaction)
        render(conn, "index.json", accounting_inventories: inventories)
      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> render(KakebosanWeb.ErrorView, "error.json", reason: reason)
    end

  end

  def create(conn, %{"inventory" => inventory_params}) do
    changeset = Inventory.changeset(%Inventory{}, inventory_params)

    case Repo.insert(changeset) do
      {:ok, inventory} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", inventory_path(conn, :show, inventory))
        |> render("show.json", inventory: inventory |> Repo.preload(:item) |> Repo.preload(clearance_transaction: [entries: [:item, :side]]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KakebosanWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}) do
    render(conn, "show.json", inventory: conn.assigns.inventory)
  end

  def update(conn, %{"id" => _id, "inventory" => inventory_params}) do
    user = get_session(conn, :current_user)
    changeset =
      conn.assigns.inventory
      |> Inventory.changeset(inventory_params |> Map.put("user_id", user.id))

    case Repo.update(changeset) do
      {:ok, inventory} ->
        render(conn, "show.json", inventory: inventory)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KakebosanWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(conn.assigns.inventory)

    send_resp(conn, :no_content, "")
  end
end
