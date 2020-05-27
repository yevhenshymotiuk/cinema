defmodule CinemaWeb.SeatLive.SeatComponent do
  use CinemaWeb, :live_component

  def update(assigns, socket) do
    seat = assigns.seat

    reserved = not is_nil(seat.reservation_ip)
    free = is_nil(seat.ticket) and not reserved
    selected = assigns.seat in assigns.selected_seats

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(free: free)
      |> assign(reserved: reserved)
      |> assign(selected: selected)
    }
  end
end
