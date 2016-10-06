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
config :kakebosan, Kakebosan.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OTFFgNI5OSoJLNCXvxeWDQjWUGa+hwUU+7h7dHoe46508PoTGUEZc6Fk3VtMlwyr",
  render_errors: [view: Kakebosan.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kakebosan.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
