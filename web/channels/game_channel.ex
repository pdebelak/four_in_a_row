defmodule Four.GameChannel do
  use Phoenix.Channel

  intercept ["new_move"]

  def join("game:" <> _id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_move", payload, socket) do
    broadcast socket, "new_move", payload
    {:noreply, socket}
  end

  def handle_out("new_move", payload, socket) do
    push socket, "new_move", payload
    {:noreply, socket}
  end
end
