# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :connect_four, ConnectFour.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+nD/U/5D97cKeU1+HfqQ7o5o5weIf4ny6NtV102PoutSkJ8umZ76YmNC28BxuRXf",
  render_errors: [view: ConnectFour.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ConnectFour.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"