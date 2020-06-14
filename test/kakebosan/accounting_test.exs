defmodule Kakebosan.AccountingTest do
  use Kakebosan.DataCase

  alias Kakebosan.Accounting

  describe "accounting_items" do
    alias Kakebosan.Accounting.Item

    @valid_attrs %{name: "some name", type_id: Accounting.Type.asset().id, user_id: 0}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounting.create_item()

      item
    end

    def build(:user) do
      %Kakebosan.User{id: 0, name: "test user"}
    end

    test "list_accounting_items/0 returns all accounting_items" do
      user = build(:user)
      item = item_fixture(user_id: user.id)
      assert Accounting.list_items(user) == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Accounting.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Accounting.create_item(@valid_attrs)
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Accounting.update_item(item, @update_attrs)
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounting.update_item(item, @invalid_attrs)
      assert item == Accounting.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Accounting.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Accounting.change_item(item)
    end
  end

  describe "accounting_transactions" do
    alias Kakebosan.Accounting.Transaction

    @valid_attrs %{date: "2010-04-17T14:00:00Z", description: "some description", user_id: 42}
    @update_attrs %{date: "2011-05-18T15:01:01Z", description: "some updated description", user_id: 43}
    @invalid_attrs %{date: nil, description: nil, user_id: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounting.create_transaction()

      transaction
    end

    test "list_accounting_transactions/0 returns all accounting_transactions" do
      transaction = transaction_fixture()
      assert Accounting.list_accounting_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Accounting.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Accounting.create_transaction(@valid_attrs)
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert transaction.description == "some description"
      assert transaction.user_id == 42
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Accounting.update_transaction(transaction, @update_attrs)
      assert transaction.date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert transaction.description == "some updated description"
      assert transaction.user_id == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounting.update_transaction(transaction, @invalid_attrs)
      assert transaction == Accounting.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Accounting.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Accounting.change_transaction(transaction)
    end
  end
end
