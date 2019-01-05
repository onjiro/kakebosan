defmodule KakebosanWeb.Accounting.TypeView do
  use Kakebosan.Web, :view

  def render("type.json", %{type: type}) do
    %{
      id: type.id,
      name: type.name,
      side_id: type.side_id
    }
  end
end
