defmodule KakebosanWeb.PageController do
  use Kakebosan.Web, :controller

  def index(conn, _params) do
    case get_session(conn, :current_user) do
      nil -> render conn, "index.html"
      _ -> render conn, "app.html"
    end
  end
end
