defmodule CinemaWeb.SeatLive.SeatsComponent do
  use CinemaWeb, :live_component

  def update(assigns, socket) do
    seats =
      assigns.seats
      |> Enum.sort_by(& &1.number)
      |> Enum.chunk_every(5)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(seats: seats)
      |> assign(selected_seats: Enum.reverse(assigns.selected_seats))
    }
  end
end
