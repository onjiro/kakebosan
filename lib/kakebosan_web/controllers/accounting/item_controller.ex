defmodule KakebosanWeb.Accounting.ItemController do
  use KakebosanWeb, :controller

  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Item

  action_fallback KakebosanWeb.FallbackController

  def index(conn, _params) do
    accounting_items =
      get_current_user(conn)
      |> Accounting.list_items()

    render(conn, "index.json", accounting_items: accounting_items)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"item" => item_params}) do
    with {:ok, %Item{} = item} <-
           item_params
           |> Map.put("user_id", user.id)
           |> Accounting.create_item() do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.item_path(conn, :show, item))
      |> render("show.json", item: item)
    end
  end

  def show(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    item = Accounting.get_item!(id)

    with :ok <- Bodyguard.permit(Kakebosan.Accounting, :get_item, user, item) do
      render(conn, "show.json", item: item)
    end
  end

  def update(%{assigns: %{current_user: user}} = conn, %{"id" => id, "item" => item_params}) do
    item = Accounting.get_item!(id)

    with :ok <- Bodyguard.permit(Kakebosan.Accounting, :update_item, user, item),
         {:ok, %Item{} = item} <-
           Accounting.update_item(
             item,
             item_params
             |> Map.put("user_id", user.id)
           ) do
      render(conn, "show.json", item: item)
    end
  end

  def delete(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    item = Accounting.get_item!(id)

    with :ok <- Bodyguard.permit(Kakebosan.Accounting, :delete_item, user, item),
         {:ok, %Item{}} <- Accounting.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end
end
