alias KakebosanWeb.User
defimpl Canada.Can, for: User do
  def can?(%User{ id: user_id }, action, %KakebosanWeb.Accounting.Transaction{ user_id: user_id })
    when action in [:show, :update, :delete], do: true

  def can?(%User{ id: user_id }, action, %KakebosanWeb.Accounting.Item{ user_id: user_id })
    when action in [:show, :update, :delete], do: true

  def can?(%User{ id: user_id }, action, %KakebosanWeb.Accounting.Inventory{ user_id: user_id })
    when action in [:show, :update, :delete], do: true

  def can?(%User{ id: _user_id }, _, _), do: false
end
