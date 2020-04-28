defmodule CinemaWeb.SeatLive.Show do
  use CinemaWeb, :live_view

  alias Cinema.Seats
  alias Cinema.Tickets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "hall_id" => hall_id}, _, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:seat, Seats.get_seat!(id))
      |> assign(:hall_id, hall_id)
    }
  end

  @impl true
  def handle_event("buy-ticket", _, socket) do
    Tickets.create_ticket(socket.assigns.seat)

    {
      :noreply,
      put_flash(socket, :info, "Ticket was successfully bought")
    }
  end

  defp page_title(:show), do: "Show Seat"
  defp page_title(:edit), do: "Edit Seat"
end
