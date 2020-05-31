# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kakebosan,
  ecto_repos: [Kakebosan.Repo]

# Configures the endpoint
config :kakebosan, KakebosanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Je2OD3paVW4OtqJc5UEMb1/umR71dDfLvZZFGgm3JtESInJi8aaYncsdjh7+h3+d",
  render_errors: [view: KakebosanWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kakebosan.PubSub,
  live_view: [signing_salt: "I6RQblju"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile openid"]}
  ]

# read client ID/secret from the environment variables in the run time
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: {System, :get_env, ["GOOGLE_CLIENT_ID"]},
  client_secret: {System, :get_env, ["GOOGLE_CLIENT_SECRET"]}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
