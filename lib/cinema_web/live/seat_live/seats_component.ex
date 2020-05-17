defmodule CinemaWeb.SeatLive.SeatsComponent do
  use CinemaWeb, :live_component

  @seats_in_row 5

  def update(assigns, socket) do
    seats =
      assigns.seats
      |> Enum.sort_by(& &1.number)
      |> Enum.chunk_every(@seats_in_row)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(hall_id: assigns.id)
      |> assign(seats: seats)
      |> assign(selected_seats: Enum.reverse(assigns.selected_seats))
    }
  end

  def row(n) do
    if rem(n, @seats_in_row) == 0 do
      div(n, @seats_in_row)
    else
      div(n, @seats_in_row) + 1
    end
  end
end
