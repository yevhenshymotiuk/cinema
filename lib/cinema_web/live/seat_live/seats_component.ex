defmodule CinemaWeb.SeatLive.SeatsComponent do
  use CinemaWeb, :live_component

  @seats_in_row 10

  def update(assigns, socket) do
    seats =
      assigns.seats
      |> Enum.sort_by(& &1.number)

    if Enum.any?(seats, &(not is_nil(&1.reservation_ip))), do: IO.puts("Reservation")

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
