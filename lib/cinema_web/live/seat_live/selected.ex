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
    selected_seats_data = socket.assigns.selected_seats_data
      
    selected_seats = Enum.map(selected_seats_data, & &1.seat)

    ticket_ids = Enum.map(selected_seats, & Seats.create_ticket!(&1).id)

    {
      :noreply,
      socket
      |> push_redirect(
        to: Routes.seat_tickets_path(
          socket,
          :tickets,
          socket.assigns.hall.id,
          selected_seats_data
          |> Enum.map(& "#{&1.seat.id}|#{&1.row}")
          |> Enum.join(",")
        )
      )
      |> put_flash(:info, "Tickets were successfully bought")
    }
  end

  defp page_title(:selected), do: "Selected seats"
end
