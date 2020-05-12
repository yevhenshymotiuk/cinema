defmodule CinemaWeb.SeatLive.Selected do
  use CinemaWeb, :live_view

  alias Cinema.{Halls, Seats}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
    %{"hall_id" => hall_id, "selected_seats_data" => selected_seats_data},
    _,
    socket
  ) do
    hall = Halls.get_hall!(hall_id)

    selected_seats_data =
      selected_seats_data
      |> String.split(",")
      |> Enum.map(
        fn x ->
          [id, row] = String.split(x, "|")

          %{seat: Seats.get_seat!(id), row: row}
        end
      )

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:hall, hall)
      |> assign(:selected_seats_data, selected_seats_data)
    }
  end

  @impl true
  def handle_event("buy-tickets", _, socket) do
    selected_seats = Enum.map(socket.assigns.selected_seats_data, & &1.seat)

    Enum.each(selected_seats, & Seats.create_ticket(&1))

    {
      :noreply,
      socket
      |> assign(selected_seats: [])
      |> push_redirect(to: Routes.seat_index_path(socket, :index, socket.assigns.hall.id))
      |> put_flash(:info, "Tickets were successfully bought")
    }
  end

  defp page_title(:selected), do: "Selected seats"
end
