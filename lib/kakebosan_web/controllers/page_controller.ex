defmodule KakebosanWeb.PageController do
  use KakebosanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
