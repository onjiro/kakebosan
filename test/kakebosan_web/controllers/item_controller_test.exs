defmodule KakebosanWeb.ItemControllerTest do
  use KakebosanWeb.ConnCase

  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Item

  @create_attrs %{
    name: "some name",
    type_id: Accounting.Type.asset().id
  }
  @update_attrs %{
    name: "some updated name",
    type_id: Accounting.Type.expense().id
  }
  @invalid_attrs %{name: nil}

  def fixture(:item, user_id) do
    {:ok, item} = Accounting.create_item(@create_attrs |> Map.put(:user_id, user_id))
    item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "lists all of own accounting_items", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create item" do
    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders item when data is valid", %{conn: conn} do
      conn = post(conn, Routes.item_path(conn, :create), item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.item_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.item_path(conn, :create), item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update item" do
    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders item when data is valid", %{
      conn: conn,
      current_user: user
    } do
      %Item{id: id} = item = fixture(:item, user.id)
      conn = put(conn, Routes.item_path(conn, :update, item), item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.item_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders errors when data is invalid", %{
      conn: conn,
      current_user: user
    } do
      item = fixture(:item, user.id)
      conn = put(conn, Routes.item_path(conn, :update, item), item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete item" do
    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "deletes chosen item", %{conn: conn, current_user: user} do
      item = fixture(:item, user.id)
      conn = delete(conn, Routes.item_path(conn, :delete, item))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.item_path(conn, :show, item))
      end
    end
  end
end
