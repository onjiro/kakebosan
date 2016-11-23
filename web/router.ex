defmodule Kakebosan.Router do
  use Kakebosan.Web, :router

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
  end

  scope "/", Kakebosan do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", Kakebosan do
    pipe_through :browser
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/identity/callback", AuthController, :identity_callback # todo 開発時のみに制限する
  end

  scope "/api", Kakebosan do
    pipe_through :api
    resources "/items", Accounting.ItemController
    resources "/transactions", Accounting.TransactionController
  end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with `@current_user`.
  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end
