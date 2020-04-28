defmodule CinemaWeb.SeatLive.SeatComponent do
  use CinemaWeb, :live_component

  def update(assigns, socket) do
    state =
      if assigns.seat.ticket do
        "sold"
      else
        "free"
      end

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(state: state)
    }
  end
end
