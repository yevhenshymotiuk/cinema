defmodule CinemaWeb.SeatLive.Index do
  use CinemaWeb, :live_view

  alias Cinema.{Halls, Seats}
  alias Cinema.Seats.Seat

  @impl true
  def mount(%{"hall_id" => hall_id}, _session, socket) do
    if connected?(socket), do: Seats.subscribe()

    {
      :ok,
      socket
      |> assign(seats: fetch_seats(hall_id))
      |> assign(hall: Halls.get_hall!(hall_id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Seat")
    |> assign(:seat, Seats.get_seat!(id))
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
  def handle_event("delete", %{"id" => id}, socket) do
    seat = Seats.get_seat!(id)
    {:ok, _} = Seats.delete_seat(seat)

    {:noreply, assign(socket, :seats, fetch_seats(socket.assigns.hall.id))}
  end

  @impl true
  def handle_info({:seat_created, seat}, socket) do
    {:noreply, update(socket, :seats, fn seats -> [seat | seats] end)}
  end

  def handle_info({:seat_updated, seat}, socket) do
    {
      :noreply,
      update(
        socket,
        :seats,
        & Enum.map(&1, fn s -> if s.id == seat.id, do: seat, else: s end)
      )
    }
  end

  defp fetch_seats(hall_id) do
    Seats.list_seats(hall_id)
  end
end
