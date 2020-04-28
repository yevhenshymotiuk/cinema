defmodule CinemaWeb.SeatLive.SeatsComponent do
  use CinemaWeb, :live_component

  alias Cinema.Repo

  def update(assigns, socket) do
    seats =
      assigns.seats
      |> Repo.preload([:ticket])
      |> Enum.chunk_every(5)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(seats: seats)
    }
  end
end
