defmodule KakebosanWeb.AuthController do
  use Kakebosan.Web, :controller
  alias KakebosanWeb.User
  alias Ueberauth.Strategy.Helpers
  plug Ueberauth

  @page_login_success "/"
  @page_login_failed "/"

  # 認証リクエスト
  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  # ログアウトする
  def logout(conn, _params) do
    conn
    |> put_flash(:info, "ログアウトしました")
    |> put_session(:current_user, nil)
    |> redirect(to: @page_login_success)
  end

  # 通常の oauth 認証
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Kakebosan.Repo.transaction fn() ->
      case get_or_create_user(auth) do
        %{ id: _ } = user ->
          conn
          |> put_flash(:info, "#{user.name} としてログインしました")
          |> put_session(:current_user, user)
          |> redirect(to: @page_login_success)
        _ ->
          conn
          |> put_flash(:error, "ユーザー作成に失敗しました")
          |> redirect(to: @page_login_failed)
      end
    end
  end

  # ユーザーID、パスワード方式の認証
  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Kakebosan.Repo.transaction fn() ->
      case validate_pass(auth.credentials) do
        :ok ->
          case get_or_create_user(auth) do
            %{ id: _ } = user ->
              conn
              |> put_flash(:info, "#{user.name} としてログインしました")
              |> put_session(:current_user, user)
              |> redirect(to: @page_login_success)
            _ ->
              conn
              |> put_flash(:error, "ユーザー作成に失敗しました")
              |> redirect(to: @page_login_failed)
          end
        { :error, reason } ->
          conn
          |> put_flash(:error, reason)
          |> redirect(to: @page_login_failed)
      end
    end
  end

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end
  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end
  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end
  defp validate_pass(_), do: {:error, "Password Required"}

  # ueberauth_github では uid が number で渡される
  # アプリ上で保存される型は string のため変換する。
  defp get_or_create_user(%{ uid: uid } = auth) when is_number(uid),
    do: get_or_create_user(auth |> Map.merge(%{ uid: Integer.to_string(uid) }))

  defp get_or_create_user(%{ uid: uid, provider: provider } = auth) do
    Repo.get_by(User, uid: uid, provider: Atom.to_string(provider)) || User.create_with_ueberauth(auth)
  end
end
