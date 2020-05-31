defmodule KakebosanWeb.PageController do
  use KakebosanWeb, :controller

  @doc """
  未ログイン時はindex.htmlを、ログイン時はapp.htmlを表示する。
  """
  def index(conn, _params) do
    case get_session(conn, :current_user) do
      nil -> render(conn, "index.html")
      _ -> render(conn, "app.html")
    end
  end
end
