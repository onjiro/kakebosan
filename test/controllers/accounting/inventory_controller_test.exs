defmodule KakebosanWeb.Accounting.InventoryControllerTest do
  use KakebosanWeb.ConnCase

  alias KakebosanWeb.User
  alias KakebosanWeb.Accounting.Side
  alias KakebosanWeb.Accounting.Type
  alias KakebosanWeb.Accounting.Item
  alias KakebosanWeb.Accounting.Inventory
  @valid_attrs %{user_id: 1, item_id: 2, amount: 123, date: ~N[2017-05-01 00:00:00]}
  @invalid_attrs %{amount: "hoge"}

  setup %{conn: conn} do
    user = Repo.insert! %User{id: 1, provider: "test", uid: "test"}
    Repo.insert! %Side{id: 1, name: "借方"}
    Repo.insert! %Side{id: 2, name: "貸方"}
    Repo.insert! %Type{id: 1, name: "資産", side_id: 1}
    Repo.insert! %Type{id: 2, name: "費用", side_id: 1}
    Repo.insert! %Type{id: 3, name: "負債", side_id: 2}
    Repo.insert! %Type{id: 4, name: "資本", side_id: 2}
    Repo.insert! %Type{id: 5, name: "収益", side_id: 2}
    Repo.insert! %Item{id: 1, name: "現金", selectable: true, type_id: 1, user_id: 1 }
    Repo.insert! %Item{id: 2, name: "食費", selectable: true, type_id: 2, user_id: 1 }
    Repo.insert! %Inventory{id: 1, user_id: 1, item_id: 1,
                            date: ~N[2017-04-01 00:00:00], amount: 100}
    # @see https://elixirforum.com/t/test-for-sessions-in-phoenix/2569/2
    setup_conn =
      conn
      |> bypass_through(KakebosanWeb.Router, :browser)
      |> get("/")
      |> fetch_session(:current_user)
      |> put_session(:current_user, user)
      |> send_resp(:ok, "")
    {:ok, %{conn: setup_conn}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, inventory_path(conn, :index)
    assert json_response(conn, 200)["data"] == [
      %{"id" => 1, "date" => "2017-04-01T00:00:00.000000", "amount" => 100,
        "item" => %{"id" => 1, "name" => "現金", "selectable" => true, "type_id" => 1, "description" => nil},
        "clearance_transaction" => nil }
    ]
  end

  test "shows chosen resource", %{conn: conn} do
    conn = get conn, inventory_path(conn, :show, 1)
    assert json_response(conn, 200)["data"] ==
      %{"id" => 1, "date" => "2017-04-01T00:00:00.000000", "amount" => 100,
        "item" => %{"id" => 1, "name" => "現金", "selectable" => true, "type_id" => 1, "description" => nil},
        "clearance_transaction" => nil }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, transaction_path(conn, :show, -1)
    assert json_response(conn, 404)["error"]
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, inventory_path(conn, :create), inventory: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Inventory, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, inventory_path(conn, :create), inventory: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    conn = put conn, inventory_path(conn, :update, 1), inventory: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Inventory, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = put conn, inventory_path(conn, :update, 1), inventory: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = delete conn, inventory_path(conn, :delete, 1)
    assert response(conn, 204)
    refute Repo.get(Inventory, 1)
  end
end
