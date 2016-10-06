defmodule Kakebosan.PageController do
  use Kakebosan.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
