defmodule Kakebosan.Accounting.Policy do
  @behaviour Bodyguard.Policy
  require Logger
  import Ecto.Query

  alias Kakebosan.Repo
  alias Kakebosan.User
  alias Kakebosan.Accounting

  # 勘定科目を新規作成可能
  def authorize(:create_item, _, _), do: :ok

  # 自分自身の勘定科目を表示、編集、削除を許可
  def authorize(action, %User{id: user_id}, %Accounting.Item{user_id: user_id})
      when action in [:get_item, :update_item, :delete_item],
      do: :ok

  # 自分自身の取引を新規作成、更新を許可
  def authorize(
        :create_transaction,
        %User{id: user_id},
        %Accounting.Transaction{user_id: user_id} = transaction
      ) do
    authorize_transaction_entries(transaction)
  end

  # 自分自身の取引を新規作成、更新を許可
  def authorize(
        action,
        %User{id: user_id},
        %Accounting.Transaction{user_id: user_id} = transaction
      ) do
    case action do
      :get_transaction ->
        :ok

      :update_transaction ->
        authorize_transaction_entries(transaction)

      :delete_transaction ->
        :ok

      _ ->
        :error
    end
  end

  # entriesが空なら不許可
  defp authorize_transaction_entries(%Accounting.Transaction{entries: nil}),
    do: :error

  defp authorize_transaction_entries(%Accounting.Transaction{user_id: user_id, entries: entries}) do
    item_owner_ids =
      Accounting.Item
      |> where([item], item.id in ^Enum.map(entries, fn entry -> entry.item_id end))
      |> select([item], item.user_id)
      |> Repo.all()

    debit_entries_amount =
      entries
      |> Enum.filter(fn e -> e.side_id == Accounting.Side.debit() end)
      |> Enum.reduce(0, fn entry, acc -> entry.amount + acc end)

    credit_entries_amount =
      entries
      |> Enum.filter(fn e -> e.side_id == Accounting.Side.credit() end)
      |> Enum.reduce(0, fn entry, acc -> entry.amount + acc end)

    cond do
      item_owner_ids |> Enum.any?(fn owner_id -> owner_id != user_id end) -> :error
      debit_entries_amount != credit_entries_amount -> :error
      true -> :ok
    end
  end

  # Catch-all: そのほかはすべて許可しない
  def authorize(action, user, params) do
    Logger.debug(
      "Authorize failed for action: #{action}, user_id: #{user.id}, params: #{inspect(params)}"
    )

    :error
  end
end
