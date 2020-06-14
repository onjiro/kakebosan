defmodule KakebosanWeb.TransactionControllerTest do
  use KakebosanWeb.ConnCase

  alias Kakebosan.Accounting
  alias Kakebosan.Accounting.Transaction

  @create_attrs %{
    date: "2010-04-17T14:00:00Z",
    description: "some description",
    user_id: 42
  }
  @update_attrs %{
    date: "2011-05-18T15:01:01Z",
    description: "some updated description",
    user_id: 43
  }
  @invalid_attrs %{date: nil, description: nil, user_id: nil}

  def fixture(:transaction) do
    {:ok, transaction} = Accounting.create_transaction(@create_attrs)
    transaction
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
  describe "index" do
    test "lists all accounting_transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2010-04-17T14:00:00Z",
               "description" => "some description",
               "user_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transaction" do
    setup [:create_transaction]

    test "renders transaction when data is valid", %{
      conn: conn,
      transaction: %Transaction{id: id} = transaction
    } do
      conn =
        put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2011-05-18T15:01:01Z",
               "description" => "some updated description",
               "user_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      conn =
        put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end
    end
  end

  defp create_transaction(_) do
    transaction = fixture(:transaction)
    %{transaction: transaction}
  end
end
