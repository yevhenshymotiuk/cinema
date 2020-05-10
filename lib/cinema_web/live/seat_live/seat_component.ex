defmodule CinemaWeb.SeatLive.SeatComponent do
  use CinemaWeb, :live_component

  def update(assigns, socket) do
    free = is_nil(assigns.seat.ticket)
    selected = assigns.seat in assigns.selected_seats

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(free: free)
      |> assign(selected: selected)
    }
  end
end
