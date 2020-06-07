defmodule KakebosanWeb.PageControllerTest do
  use KakebosanWeb.ConnCase

  @tag current_user: nil
  test "GET / when current_user is not set", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Googleでログイン"
  end

  @tag current_user: %{id: 0, uid: "0", name: "Test User", provider: "dummy provider"}
  test "GET / when current_user is set", %{conn: conn} do
    conn =
      conn
      |> put_session(:current_user, 1)
      |> get("/")

    assert html_response(conn, 200) =~ "ログアウト"
  end
end
