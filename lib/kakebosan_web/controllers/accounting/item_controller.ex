defmodule KakebosanWeb.Accounting.ItemController do
  use KakebosanWeb, :controller

  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Item

  action_fallback KakebosanWeb.FallbackController

  def index(conn, _params) do
    accounting_items = Accounting.list_accounting_items()
    render(conn, "index.json", accounting_items: accounting_items)
  end

  def create(conn, %{"item" => item_params}) do
    with {:ok, %Item{} = item} <- Accounting.create_item(item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.item_path(conn, :show, item))
      |> render("show.json", item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Accounting.get_item!(id)
    render(conn, "show.json", item: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Accounting.get_item!(id)

    with {:ok, %Item{} = item} <- Accounting.update_item(item, item_params) do
      render(conn, "show.json", item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Accounting.get_item!(id)

    with {:ok, %Item{}} <- Accounting.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end
end
