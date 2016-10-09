defmodule Kakebosan.Accouning.SideTest do
  use Kakebosan.ModelCase

  alias Kakebosan.Accouning.Side

  @valid_attrs %{deleted_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Side.changeset(%Side{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Side.changeset(%Side{}, @invalid_attrs)
    refute changeset.valid?
  end
end
