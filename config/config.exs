# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kakebosan,
  ecto_repos: [Kakebosan.Repo]

# Configures the endpoint
config :kakebosan, KakebosanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OTFFgNI5OSoJLNCXvxeWDQjWUGa+hwUU+7h7dHoe46508PoTGUEZc6Fk3VtMlwyr",
  render_errors: [view: KakebosanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KakebosanWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix json library
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configures Ueberauth
config :ueberauth, Ueberauth,
providers: [
  github: { Ueberauth.Strategy.Github, [] },
  twitter: { Ueberauth.Strategy.Twitter, [] },
  identity: {Ueberauth.Strategy.Identity, [
                callback_methods: ["POST"],
                uid_field: :username,
                nickname_field: :username]}]

# github auth strategy
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
client_id: System.get_env("GITHUB_CLIENT_ID"),
client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# twitter auth strategy
config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

# canary setting
config :canary, repo: Kakebosan.Repo
