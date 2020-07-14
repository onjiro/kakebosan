defmodule KakebosanWeb.Router do
  use KakebosanWeb, :router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :assign_current_user
    plug :authenticate_user_for_api
  end

  scope "/auth", KakebosanWeb do
    pipe_through :browser

    get "/logout", AuthController, :delete
    post "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", KakebosanWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", KakebosanWeb do
    pipe_through :api
    resources "/transactions", TransactionController
    resources "/items", Accounting.ItemController
    resources "/inventories", Accounting.InventoryController
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: KakebosanWeb.Telemetry
    end
  end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with `@current_user`.
  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end

  # ユーザーが認証されていない場合エラーを返す
  defp authenticate_user_for_api(conn, _) do
    case conn.assigns.current_user do
      %Kakebosan.User{} ->
        conn

      nil ->
        conn
        |> put_status(:forbidden)
        |> put_view(KakebosanWeb.ErrorView)
        |> render(:"403")
        |> halt()
    end
  end
end
