defmodule KakebosanWeb.TransactionControllerTest do
  use KakebosanWeb.ConnCase

  alias Kakebosan.Repo
  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Transaction

  @update_attrs %{
    date: "2011-05-18T15:01:01Z",
    description: "some updated description",
    user_id: 0
  }
  @invalid_attrs %{date: nil, description: nil, user_id: nil}

  def fixture(:transaction, user_id) do
    item1 = Repo.insert!(%Accounting.Item{user_id: user_id, type_id: Accounting.Type.asset().id})

    item2 =
      Repo.insert!(%Accounting.Item{user_id: user_id, type_id: Accounting.Type.expense().id})

    {:ok, transaction} =
      Accounting.create_transaction(%{
        user_id: user_id,
        date: "2010-04-17T14:00:00Z",
        description: "some description",
        entries: [
          %{
            user_id: user_id,
            item_id: item1.id,
            amount: 100,
            side_id: Accounting.Side.debit().id
          },
          %{
            user_id: user_id,
            item_id: item2.id,
            amount: 100,
            side_id: Accounting.Side.credit().id
          }
        ]
      })

    transaction
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @tag current_user: %{uid: "0", name: "Test User", provider: "dummy provider"}
  describe "index" do
    test "lists all accounting_transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    @tag current_user: %{uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders transaction when data is valid", %{
      conn: conn,
      current_user: %{id: user_id}
    } do
      item1 =
        Repo.insert!(%Accounting.Item{user_id: user_id, type_id: Accounting.Type.asset().id})

      item2 =
        Repo.insert!(%Accounting.Item{user_id: user_id, type_id: Accounting.Type.expense().id})

      conn =
        post(conn, Routes.transaction_path(conn, :create),
          transaction: %{
            date: "2010-04-17T14:00:00Z",
            description: "some description",
            entries: [
              %{item_id: item1.id, amount: 100, side_id: Accounting.Side.debit().id},
              %{item_id: item2.id, amount: 100, side_id: Accounting.Side.credit().id}
            ]
          }
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "date" => "2010-04-17T14:00:00Z",
               "description" => "some description",
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    @tag current_user: %{uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transaction" do
    @tag current_user: %{uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders transaction when data is valid", %{
      conn: conn,
      current_user: %{id: user_id}
    } do
      %Transaction{id: id} = transaction = fixture(:transaction, user_id)

      conn =
        put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "date" => "2011-05-18T15:01:01Z",
               "description" => "some updated description",
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "renders errors when data is invalid", %{conn: conn, current_user: %{id: user_id}} do
      transaction = fixture(:transaction, user_id)

      conn =
        put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction" do
    @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
    test "deletes chosen transaction", %{conn: conn, current_user: %{id: user_id}} do
      transaction = fixture(:transaction, user_id)
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end
    end
  end
end
