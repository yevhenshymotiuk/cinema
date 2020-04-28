defmodule CinemaWeb.SeatLive.SeatsComponent do
  use CinemaWeb, :live_component
  alias Cinema.Repo

  def update(assigns, socket) do
    seats =
      assigns.seats
      |> Repo.preload([:ticket])
      |> Enum.chunk_every(5)
    hall = assigns.hall;

    {:ok, socket |> assign(:seats, seats) |> assign(:hall, hall)}
  end
end
