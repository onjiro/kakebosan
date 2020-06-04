defmodule Kakebosan.Accounting.Type do
  @moduledoc """
  勘定科目の分類を表す
  """
  alias Kakebosan.Accounting.Side

  @type t :: %__MODULE__{
          id: Integer.t(),
          name: String.t(),
          side: Side.t()
        }

  defstruct id: nil,
            name: nil,
            side: nil

  @asset %{id: 1, name: "資産", side: Side.debit()}
  def asset, do: @asset
  @expense %{id: 2, name: "費用", side: Side.debit()}
  def expense, do: @expense
  @liability %{id: 3, name: "負債", side: Side.credit()}
  def liability, do: @liability
  @net_asset %{id: 4, name: "純資産", side: Side.credit()}
  def net_asset, do: @net_asset
  @revenue %{id: 5, name: "収益", side: Side.credit()}
  def revenue, do: @revenue
end
