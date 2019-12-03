defmodule ColorPickerWeb.PageController do
  use ColorPickerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
