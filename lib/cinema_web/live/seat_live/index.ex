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
      |> assign(selected_seats: [])
      |> assign(ip: get_ip(socket))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(page_title: "Edit Seat")
    |> assign(seat: Seats.get_seat!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(page_title: "New Seat")
    |>  assign(seat: %Seat{})
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

  def handle_event("select", %{"seat_id" => seat_id}, socket) do
    selected_seats = socket.assigns.selected_seats
    seat = Cinema.Repo.preload(Seats.get_seat!(seat_id), [:ticket])

    selected_seats =
      if seat in selected_seats do
        List.delete(selected_seats, seat)
      else
        [seat | selected_seats]
      end

    {
      :noreply,
      assign(socket, selected_seats: selected_seats)
    }
  end

  def handle_event("confirm-selection", _, socket) do
    hall_id = socket.assigns.hall.id
    selected_seats = socket.assigns.selected_seats

    {
      :noreply,
      push_redirect(
        socket,
        to: Routes.seat_selected_path(
          socket,
          :selected,
          hall_id,
          CinemaWeb.SeatLive.Selected.encode(selected_seats)
        )
      )
    }
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

  def get_ip(socket) do
    info = get_connect_info(socket)

    case info do
      nil -> nil

      _ ->
        info[:peer_data][:address]
        |> Tuple.to_list()
        |> Enum.join(".")
    end
  end
end
