use Mix.Config

# Configure your database
config :color_picker, ColorPicker.Repo,
  username: "anansi",
  password: "",
  database: "color_picker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :color_picker, ColorPickerWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :color_picker, :sql_sandbox, true