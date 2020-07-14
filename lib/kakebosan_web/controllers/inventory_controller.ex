defmodule KakebosanWeb.InventoryController do
  use KakebosanWeb, :controller

  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Inventory

  action_fallback KakebosanWeb.FallbackController

  def index(conn, _params) do
    inventories = Accounting.list_inventories()
    render(conn, "index.json", inventories: inventories)
  end

  def create(conn, %{"inventory" => inventory_params}) do
    with {:ok, %Inventory{} = inventory} <- Accounting.create_inventory(inventory_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.inventory_path(conn, :show, inventory))
      |> render("show.json", inventory: inventory)
    end
  end

  def show(conn, %{"id" => id}) do
    inventory = Accounting.get_inventory!(id)
    render(conn, "show.json", inventory: inventory)
  end

  def update(conn, %{"id" => id, "inventory" => inventory_params}) do
    inventory = Accounting.get_inventory!(id)

    with {:ok, %Inventory{} = inventory} <-
           Accounting.update_inventory(inventory, inventory_params) do
      render(conn, "show.json", inventory: inventory)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventory = Accounting.get_inventory!(id)

    with {:ok, %Inventory{}} <- Accounting.delete_inventory(inventory) do
      send_resp(conn, :no_content, "")
    end
  end
end
