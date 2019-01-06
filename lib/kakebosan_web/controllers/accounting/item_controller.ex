defmodule KakebosanWeb.Accounting.ItemController do
  use Kakebosan.Web, :controller

  alias KakebosanWeb.Accounting.Item
  plug :load_and_authorize_resource, model: Item
  plug :scrub_params, "item" when action in [:create, :update]

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
        |> put_resp_header("location", Routes.item_path(conn, :show, item))
        |> render("show.json", item: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KakebosanWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}) do
    case conn.assigns.item do
      nil ->
        conn
        |> put_status(404)
        |> render(KakebosanWeb.ErrorView, "404.json")
      _ ->
        render(conn, "show.json", item: conn.assigns.item)
    end
  end

  def update(conn, %{"id" => _id, "item" => item_params}) do
    item = conn.assigns.item
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        render(conn, "show.json", item: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KakebosanWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    Repo.delete!(conn.assigns.item)
    send_resp(conn, :no_content, "")
  end
end
