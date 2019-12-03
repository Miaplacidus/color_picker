defmodule ColorPickerWeb.RoomChannel do 
  use Phoenix.Channel
  alias ColorPicker.Palette
  alias ColorPickerWeb.RoomChannel

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_palette", %{"body" => body}, socket) do
    {:ok, palette} = Palette.create_palette(body)
    broadcast!(socket, "new_palette", %{ body: %{"colors" => palette.colors, "id" => palette.id}  })
    {:noreply, socket}
  end

  def handle_in("update_palette", %{"body" => body}, socket) do
    palette = Palette.get_palette(body["id"])

    palette_index = body["palette_index"]
    new_color = body["color"]

    updated_colors = 
      List.delete_at(palette.colors, palette_index) 
      |> List.insert_at(palette_index, new_color)
    
    {:ok, updated_palette} = Palette.update_palette(palette, %{ colors: updated_colors })

    broadcast!(socket, "update_palette", %{ body: %{ "id" => updated_palette.id, "colors" => updated_palette.colors }})

    {:noreply, socket}
  end

  def handle_in("delete_palette", %{"body" => body}, socket) do 
    palette = Palette.get_palette(body["id"])
    Palette.delete_palette(palette)

    broadcast!(socket, "delete_palette", %{ body: %{ id: body["id"] } })

    RoomChannel.handle_info(:after_join, socket)
  end

  def handle_info(:after_join, socket) do
    Palette.get_palettes()
    |> Enum.each(fn palette -> push(socket, "new_palette", %{
        id: palette.id,
        colors: palette.colors
      }) end)

    push(socket, "end_palette_list", %{})
    {:noreply, socket} # :noreply
  end
end