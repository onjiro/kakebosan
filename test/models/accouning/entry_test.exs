defmodule Kakebosan.Accouning.EntryTest do
  use Kakebosan.ModelCase

  alias Kakebosan.Accouning.Entry

  @valid_attrs %{amount: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Entry.changeset(%Entry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Entry.changeset(%Entry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
