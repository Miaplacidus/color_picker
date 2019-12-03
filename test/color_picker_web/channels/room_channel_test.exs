defmodule ColorPickerWeb.RoomChannelTest do
  use ColorPickerWeb.ChannelCase

  alias ColorPickerWeb.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  @tag :pending
  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "all"})
    assert_reply(ref, :ok, %{"hello" => "all"})
  end

  @tag :pending
  test "shout broadcasts to room:lobby", %{socket: socket} do
    push(socket, "shout", %{"name" => "Alex", "message" => "hello"})
    assert_broadcast("shout", %{"name" => "Alex", "message" => "hello"})
  end

  @tag :pending
  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push("broadcast", %{"some" => "data"})
  end

  @tag :pending
  test "handle_info pushes existing messages to clients", %{socket: socket} do
    # first save a message to DB:
    RoomChannel.handle_in("shout", %{"name" => "Alex", "message" => "hello"}, socket)
    # then handle "broadcasting" the message using handle_info
    {:noreply, sock} = RoomChannel.handle_info(:after_join, socket)
    assert sock == socket
  end
end