defmodule Kakebosan.AccountingTest do
  use Kakebosan.DataCase

  alias Kakebosan.Accounting

  describe "accounting_items" do
    alias Kakebosan.Accounting.Item

    @valid_attrs %{name: "some name", type_id: Accounting.Type.asset().id}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    setup do
      user = Repo.insert!(%Kakebosan.User{name: "test user"})

      {:ok, %{user: user}}
    end

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounting.create_item()

      item
    end

    test "list_items/0 returns all accounting_items", %{user: user} do
      item = item_fixture(user_id: user.id)
      assert Accounting.list_items(user) == [item]
    end

    test "get_item!/1 returns the item with given id", %{user: user} do
      item = item_fixture(user_id: user.id)
      assert Accounting.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item", %{user: user} do
      assert {:ok, %Item{} = item} =
               @valid_attrs
               |> Enum.into(%{user_id: user.id})
               |> Accounting.create_item()

      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item", %{user: user} do
      item = item_fixture(user_id: user.id)
      assert {:ok, %Item{} = item} = Accounting.update_item(item, @update_attrs)
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset", %{user: user} do
      item = item_fixture(user_id: user.id)
      assert {:error, %Ecto.Changeset{}} = Accounting.update_item(item, @invalid_attrs)
      assert item == Accounting.get_item!(item.id)
    end

    test "delete_item/1 deletes the item", %{user: user} do
      item = item_fixture(user_id: user.id)
      assert {:ok, %Item{}} = Accounting.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset", %{user: user} do
      item = item_fixture(user_id: user.id)
      assert %Ecto.Changeset{} = Accounting.change_item(item)
    end
  end

  describe "accounting_transactions" do
    alias Kakebosan.Accounting.Transaction

    @valid_attrs %{
      date: "2010-04-17T14:00:00Z",
      description: "some description",
      entries: [
        %{item_id: 1, side_id: Accounting.Side.debit().id, amount: 100},
        %{item_id: 2, side_id: Accounting.Side.credit().id, amount: 100}
      ]
    }
    @update_attrs %{
      date: "2011-05-18T15:01:01Z",
      description: "some updated description"
    }
    @invalid_attrs %{date: nil, description: nil}

    setup do
      user = Repo.insert!(%Kakebosan.User{name: "test user"})

      item1 =
        Repo.insert!(%Accounting.Item{user_id: user.id, type_id: Accounting.Type.asset().id})

      item2 =
        Repo.insert!(%Accounting.Item{user_id: user.id, type_id: Accounting.Type.expense().id})

      {:ok, %{id: transaction_id}} =
        Accounting.create_transaction(%{
          user_id: user.id,
          date: "2010-04-17T14:00:00Z",
          description: "some description",
          entries: [
            %{
              user_id: user.id,
              item_id: item1.id,
              side_id: Accounting.Side.debit().id,
              amount: 100
            },
            %{
              user_id: user.id,
              item_id: item2.id,
              side_id: Accounting.Side.credit().id,
              amount: 100
            }
          ]
        })

      {:ok,
       %{
         user: user,
         transaction: Accounting.get_transaction!(transaction_id),
         item1: item1,
         item2: item2
       }}
    end

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        %{
          entries:
            @valid_attrs.entries
            |> Enum.map(fn entry -> Enum.into(%{user_id: attrs.user_id}, entry) end)
        }
        |> Enum.into(attrs)
        |> Enum.into(@valid_attrs)
        |> Accounting.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all accounting_transactions, including entries", %{
      user: user,
      transaction: transaction
    } do
      assert Accounting.list_transactions(user) |> Repo.preload([:entries]) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id", %{transaction: transaction} do
      assert Accounting.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{
      user: user,
      item1: item1,
      item2: item2
    } do
      assert {:ok, %Transaction{} = transaction} =
               Accounting.create_transaction(%{
                 user_id: user.id,
                 date: "2010-04-17T14:00:00Z",
                 description: "some description",
                 entries: [
                   %{
                     user_id: user.id,
                     item_id: item1.id,
                     side_id: Accounting.Side.debit().id,
                     amount: 100
                   },
                   %{
                     user_id: user.id,
                     item_id: item2.id,
                     side_id: Accounting.Side.credit().id,
                     amount: 100
                   }
                 ]
               })

      assert transaction.date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert transaction.description == "some description"
      assert transaction.user_id == user.id
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction", %{
      user: user,
      transaction: transaction
    } do
      assert {:ok, %Transaction{} = transaction} =
               Accounting.update_transaction(transaction, @update_attrs)

      assert transaction.date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert transaction.description == "some updated description"
      assert transaction.user_id == user.id
    end

    test "update_transaction/2 with invalid data returns error changeset", %{
      transaction: transaction
    } do
      assert {:error, %Ecto.Changeset{}} =
               Accounting.update_transaction(transaction, @invalid_attrs)

      assert transaction == Accounting.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction", %{transaction: transaction} do
      assert {:ok, %Transaction{}} = Accounting.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset", %{transaction: transaction} do
      assert %Ecto.Changeset{} = Accounting.change_transaction(transaction)
    end
  end

  describe "accounting_inventories" do
    alias Kakebosan.Accounting.Inventory

    @valid_attrs %{amount: 42, date: ~N[2010-04-17 14:00:00]}
    @update_attrs %{amount: 43, date: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{amount: nil, date: nil}

    setup do
      user = Repo.insert!(%Kakebosan.User{name: "test user"})

      item1 =
        Repo.insert!(%Accounting.Item{user_id: user.id, type_id: Accounting.Type.asset().id})

      item2 =
        Repo.insert!(%Accounting.Item{user_id: user.id, type_id: Accounting.Type.expense().id})

      transaction =
        Repo.insert!(%Accounting.Transaction{
          user_id: user.id,
          date: ~U[2010-04-17 14:00:00Z],
          description: "some description",
          entries: [
            %{
              item_id: item1.id,
              side_id: Accounting.Side.debit().id,
              amount: 100
            },
            %{
              item_id: item2.id,
              side_id: Accounting.Side.credit().id,
              amount: 100
            }
          ]
        })

      {:ok,
       %{
         user: user,
         transaction: transaction,
         item1: item1,
         item2: item2
       }}
    end

    def inventory_fixture(attrs \\ %{}) do
      {:ok, inventory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounting.create_inventory()

      inventory
    end

    test "list_accounting_inventories/0 returns all accounting_inventories" do
      inventory = inventory_fixture()
      assert Accounting.list_accounting_inventories() == [inventory]
    end

    test "get_inventory!/1 returns the inventory with given id" do
      inventory = inventory_fixture()
      assert Accounting.get_inventory!(inventory.id) == inventory
    end

    test "create_inventory/1 with valid data creates a inventory", %{
      user: %{id: user_id},
      item1: %{id: item_id}
    } do
      assert {:ok, %Inventory{} = inventory} =
               Accounting.create_inventory(%{
                 user_id: user_id,
                 item_id: item_id,
                 date: ~U[2020-07-18 23:00:00Z],
                 amount: 1000
               })

      assert inventory.item_id == item_id
      assert inventory.amount == 1000
      assert inventory.date == ~U[2020-07-18 23:00:00Z]
    end

    test "create_inventory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_inventory(@invalid_attrs)
    end

    test "update_inventory/2 with valid data updates the inventory" do
      inventory = inventory_fixture()

      assert {:ok, %Inventory{} = inventory} =
               Accounting.update_inventory(inventory, @update_attrs)

      assert inventory.amount == 43
      assert inventory.date == ~N[2011-05-18 15:01:01]
    end

    test "update_inventory/2 with invalid data returns error changeset" do
      inventory = inventory_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounting.update_inventory(inventory, @invalid_attrs)
      assert inventory == Accounting.get_inventory!(inventory.id)
    end

    test "delete_inventory/1 deletes the inventory" do
      inventory = inventory_fixture()
      assert {:ok, %Inventory{}} = Accounting.delete_inventory(inventory)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_inventory!(inventory.id) end
    end

    test "change_inventory/1 returns a inventory changeset" do
      inventory = inventory_fixture()
      assert %Ecto.Changeset{} = Accounting.change_inventory(inventory)
    end
  end
end
