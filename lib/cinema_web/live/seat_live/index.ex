defmodule CinemaWeb.SeatLive.Index do
  use CinemaWeb, :live_view

  alias Cinema.Hall
  alias Cinema.Hall.Seat

  @impl true
  def mount(%{"hall_id" => hall_id}, _session, socket) do
    {
      :ok,
      socket
      |> assign(seats: fetch_seats(hall_id))
      |> assign(hall: Cinema.Lobby.get_hall!(hall_id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Seat")
    |> assign(:seat, Hall.get_seat!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Seat")
    |> assign(:seat, %Seat{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Seats")
    |> assign(:seat, nil)
  end

  @impl true
  def handle_event("delete", %{"hall_number" => hall_number, "id" => id}, socket) do
    seat = Hall.get_seat!(id)
    {:ok, _} = Hall.delete_seat(seat)

    {:noreply, assign(socket, :seats, fetch_seats(hall_number))}
  end

  defp fetch_seats(hall_id) do
    Hall.list_seats(hall_id)
  end
end
