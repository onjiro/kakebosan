defmodule KakebosanWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use KakebosanWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import KakebosanWeb.ConnCase

      alias KakebosanWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint KakebosanWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kakebosan.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Kakebosan.Repo, {:shared, self()})
    end

    conn =
      Phoenix.ConnTest.build_conn()
      |> Phoenix.ConnTest.init_test_session(%{})

    {:ok, conn: conn}
  end

  setup tags do
    if tags[:current_user] do
      current_user =
        case tags[:current_user] do
          nil ->
            nil

          current_user ->
            %Kakebosan.User{}
            |> Kakebosan.User.changeset(current_user)
            |> Kakebosan.Repo.insert!()
        end

      conn =
        tags[:conn]
        |> Plug.Conn.put_session(:current_user, current_user)

      {:ok, current_user: current_user, conn: conn}
    else
      :ok
    end
  end
end
