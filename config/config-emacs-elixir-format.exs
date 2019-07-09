# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ideaPool,
  ecto_repos: [IdeaPool.Repo]

# Configures the endpoint
config :ideaPool, IdeaPoolWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z1R+36pwQSkAzgymS/pvdTI/UdMJ+Lmfn6nVHDiQ3ywsZEll4QqNTSNhWEbKprCC",
  render_errors: [view: IdeaPoolWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: IdeaPool.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ideaPool, IdeaPool.Accounts.Guardian,
  issuer: "ideaPool",
  secret_key: "I4/qp6L9i3lAd0RpzOZEdHfOvgDgbkH7jTCE2MGM3HM77aBiM5XdP2qvoYgr433C"
