defmodule Kakebosan.Repo do
  use Ecto.Repo,
    otp_app: :kakebosan,
    adapter: Ecto.Adapters.Postgres
end
