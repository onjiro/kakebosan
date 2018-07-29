defmodule KakebosanWeb.Accounting.TransactionControllerTest do
  use KakebosanWeb.ConnCase

  alias KakebosanWeb.User
  alias KakebosanWeb.Accounting.Side
  alias KakebosanWeb.Accounting.Type
  alias KakebosanWeb.Accounting.Item
  alias KakebosanWeb.Accounting.Entry
  alias KakebosanWeb.Accounting.Transaction
  @valid_attrs %{ date: ~N[2017-04-01 00:00:00],
                  entries: [%{side_id: 1, amount: 200, item_id: 1},
                            %{side_id: 2, amount: 200, item_id: 2}] }
  @invalid_attrs %{ date: "hoge" }

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

    Repo.insert! %Transaction{id: 0, user_id: 1, date: ~N[2014-01-01 00:00:00]}
    Repo.insert! %Entry{id: -1, transaction_id: 0, item_id: 1, side_id: 1, user_id: 1, amount: 100 }
    Repo.insert! %Entry{id: -2, transaction_id: 0, item_id: 2, side_id: 2, user_id: 1, amount: 100 }
    Repo.insert! %Transaction{id: -1, user_id: 1, date: ~N[2014-02-01 00:00:00]}
    Repo.insert! %Entry{id: -3, transaction_id: -1, item_id: 1, side_id: 1, user_id: 1, amount: 300 }
    Repo.insert! %Entry{id: -4, transaction_id: -1, item_id: 2, side_id: 2, user_id: 1, amount: 300 }

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
    conn = get conn, transaction_path(conn, :index)
    assert json_response(conn, 200)["data"] ==
      [%{"id" => 0, "date" => "2014-01-01T00:00:00.000000", "description" => nil, "entries" => [
          %{"id" => -1, "side_id" => 1, "amount" => 100,
            "item" => %{"id" => 1, "name" => "現金", "selectable" => true, "type_id" => 1, "description" => nil}},
          %{"id" => -2, "side_id" => 2, "amount" => 100,
            "item" => %{"id" => 2, "name" => "食費", "selectable" => true, "type_id" => 2, "description" => nil}}]},
      %{"id" => -1, "date" => "2014-02-01T00:00:00.000000", "description" => nil, "entries" => [
          %{"id" => -3, "side_id" => 1, "amount" => 300,
            "item" => %{"id" => 1, "name" => "現金", "selectable" => true, "type_id" => 1, "description" => nil}},
          %{"id" => -4, "side_id" => 2, "amount" => 300,
            "item" => %{"id" => 2, "name" => "食費", "selectable" => true, "type_id" => 2, "description" => nil}}]}]
  end

  test "lists limited entries on index with date condition", %{conn: conn} do
    conn = get conn, transaction_path(conn, :index,
      date_from: "2014-01-01T00:00:00Z", date_to: "2014-01-31T23:59:59")
    assert json_response(conn, 200)["data"] ==
      [%{"id" => 0, "date" => "2014-01-01T00:00:00.000000", "description" => nil, "entries" => [
          %{"id" => -1, "side_id" => 1, "amount" => 100,
            "item" => %{"id" => 1, "name" => "現金", "selectable" => true, "type_id" => 1, "description" => nil}},
          %{"id" => -2, "side_id" => 2, "amount" => 100,
            "item" => %{"id" => 2, "name" => "食費", "selectable" => true, "type_id" => 2, "description" => nil}}]}]
  end

  test "shows chosen resource", %{conn: conn} do
    conn = get conn, transaction_path(conn, :show, 0)
    assert json_response(conn, 200)["data"] ==
      %{"id" => 0, "date" => "2014-01-01T00:00:00.000000", "description" => nil, "entries" => [
          %{"id" => -1, "side_id" => 1, "amount" => 100,
            "item" => %{"id" => 1, "name" => "現金", "selectable" => true, "type_id" => 1, "description" => nil}},
          %{"id" => -2, "side_id" => 2, "amount" => 100,
            "item" => %{"id" => 2, "name" => "食費", "selectable" => true, "type_id" => 2, "description" => nil}}]}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, transaction_path(conn, :show, -2)
    assert json_response(conn, 404)["error"]
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, transaction_path(conn, :create), transaction: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by!(Transaction, %{ date: @valid_attrs[:date] })
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, transaction_path(conn, :create), transaction: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    conn = put conn, transaction_path(conn, :update, 0), transaction: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    transaction = Repo.get_by!(Transaction, %{ date: @valid_attrs[:date] })
    assert transaction
    assert Enum.count(Repo.preload(transaction, :entries).entries) == 2
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = put conn, transaction_path(conn, :update, 0), transaction: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = delete conn, transaction_path(conn, :delete, 0)
    assert response(conn, 204)
    refute Repo.get(Transaction, 0)
  end
end
