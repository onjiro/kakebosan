defmodule KakebosanWeb.AuthController do
  use KakebosanWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  @page_login_success "/"
  @page_login_failed "/"

  @doc """
  各プロバイダーの認証リクエストを受け取るハンドラー
  get /auth/:provider
  """
  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  @doc """
  各プロバイダーからのコールバックで成功時に呼ばれるハンドラー
  get /auth/:provider/callback
  post /auth/:provider/callback
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} としてログインしました")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: @page_login_success)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: @page_login_failed)
    end
  end

  @doc """
  各プロバイダーからのコールバックで失敗時に呼ばれるハンドラー
  """
  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "ログインできませんでした。")
    |> redirect(to: @page_login_failed)
  end

  @doc """
  ログアウトのリクエストを受け取るハンドラー
  post /auth/logout
  """
  def delete(conn, _params) do
    conn
    |> put_flash(:info, "ログアウトしました")
    |> clear_session()
    |> redirect(to: @page_login_success)
  end
end
