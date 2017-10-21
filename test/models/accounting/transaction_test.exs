defmodule KakebosanWeb.Accounting.TransactionTest do
  use KakebosanWeb.ModelCase

  alias KakebosanWeb.Accounting.Transaction

  @valid_attrs %{date: ~N[2010-04-17 14:00:00], description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
