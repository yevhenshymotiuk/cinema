defmodule CinemaWeb.SeatLive.SeatComponent do
  use CinemaWeb, :live_component

  def update(assigns, socket) do
    free = is_nil(assigns.seat.ticket)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(free: free)
    }
  end
end
