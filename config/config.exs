# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cinema,
  ecto_repos: [Cinema.Repo]

# Configures the endpoint
config :cinema, CinemaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iWfJvhOcU3jIWGxg+CcWR7UhPjIZ7eawnQXTEhlzhDQ8s4rn4J2mguLhm9TLdAgh",
  render_errors: [view: CinemaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Cinema.PubSub,
  live_view: [signing_salt: "PwRl3Py1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "config.secret.exs"
import_config "#{Mix.env()}.exs"
