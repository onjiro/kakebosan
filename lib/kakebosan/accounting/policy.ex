defmodule Kakebosan.Accounting.Policy do
  @behaviour Bodyguard.Policy
  @behaviour Bodyguard.Schema

  alias Kakebosan.User
  alias Kakebosan.Accounting

  # 勘定科目を新規作成可能
  def authorize(:create_item, _, _), do: :ok

  # 自分自身の勘定科目を表示、編集、削除を許可
  def authorize(action, %User{id: user_id}, %Accounting.Item{user_id: user_id})
      when action in [:get_item, :update_item, :delete_item],
      do: :ok

  # Catch-all: そのほかはすべて許可しない
  def authorize(_, _, _), do: :error
end
