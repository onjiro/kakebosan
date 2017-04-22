defmodule Kakebosan.Accounting.ItemControllerTest do
  use Kakebosan.ConnCase

  alias Kakebosan.User
  alias Kakebosan.Accounting.Side
  alias Kakebosan.Accounting.Type
  alias Kakebosan.Accounting.Item
  @valid_attrs %{ name: "some content", user_id: 1, type_id: 1 }
  @invalid_attrs %{ user_id: "hoge" }

  setup %{conn: conn} do
    user = Repo.insert! %User{id: 1, provider: "test", uid: "test"}
    Repo.insert! %Side{id: 1 , name: "借方"}
    Repo.insert! %Side{id: 2 , name: "貸方"}
    Repo.insert! %Type{id: 1 , name: "資産", side_id: 1}
    Repo.insert! %Type{id: 2 , name: "費用", side_id: 1}
    Repo.insert! %Type{id: 3 , name: "負債", side_id: 2}
    Repo.insert! %Type{id: 4 , name: "資本", side_id: 2}
    Repo.insert! %Type{id: 5 , name: "収益", side_id: 2}
    # @see https://elixirforum.com/t/test-for-sessions-in-phoenix/2569/2
    setup_conn =
      conn
      |> bypass_through(Kakebosan.Router, :browser)
      |> post("/")
      |> fetch_session(:current_user)
      |> put_session(:current_user, user)
      |> send_resp(:ok, "")
    {:ok, %{conn: setup_conn}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    item = Repo.insert! %Item{name: "test", selectable: true, user_id: 1, type_id: 1}
    conn = get conn, item_path(conn, :show, item)
    assert json_response(conn, 200)["data"] == %{"id" => item.id, "name" => item.name, "type_id" => 1,
                                                "selectable" => true, "description" => nil }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, item_path(conn, :show, -1)
    assert json_response(conn, 404)["error"]
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, item_path(conn, :create), item: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Item, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_path(conn, :create), item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    item = Repo.insert! %Item{name: "test", selectable: true, user_id: 1, type_id: 1}
    conn = put conn, item_path(conn, :update, item), item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Item, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    item = Repo.insert! %Item{name: "test", selectable: true, user_id: 1, type_id: 1}
    conn = put conn, item_path(conn, :update, item), item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    item = Repo.insert! %Item{name: "test", selectable: true, user_id: 1, type_id: 1}
    conn = delete conn, item_path(conn, :delete, item)
    assert response(conn, 204)
    refute Repo.get(Item, item.id)
  end
end
