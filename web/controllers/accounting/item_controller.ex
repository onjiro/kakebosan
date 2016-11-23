defmodule Kakebosan.Accounting.ItemController do
  use Kakebosan.Web, :controller

  alias Kakebosan.Accounting.Item
  plug :load_and_authorize_resource, model: Item
  plug :scrub_params, "accounting_item" when action in [:create, :update]

  def index(conn, _params) do
    user = get_session(conn, :current_user)
    items = Repo.all(
      from i in Item,
      where: i.user_id == ^user.id,
      order_by: [i.id]
    )
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"item" => item_params}) do
    changeset = Item.changeset(%Item{}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_path(conn, :show, item))
        |> render("show.json", item: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Kakebosan.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", item: conn.assigns.item)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = conn.assigns.item
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        render(conn, "show.json", item: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Kakebosan.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.delete!(conn.assigns.item)
    send_resp(conn, :no_content, "")
  end
end
