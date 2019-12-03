defmodule ColorPicker.Repo do
  use Ecto.Repo,
    otp_app: :color_picker,
    adapter: Ecto.Adapters.Postgres
end
