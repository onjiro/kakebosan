defmodule KakebosanWeb.PageControllerTest do
  use KakebosanWeb.ConnCase

  test "GET / when current_user is not set", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Googleでログイン"
  end

  test "GET / when current_user is set", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{})
      |> put_session(:current_user, 1)
      |> get("/")

    assert html_response(conn, 200) =~ "ログアウト"
  end
end
