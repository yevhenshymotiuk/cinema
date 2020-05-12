defmodule CinemaWeb.SeatLive.Tickets do
  use CinemaWeb, :live_view

  alias Cinema.{Halls, Seats}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
    %{
      "hall_id" => hall_id,
      "selected_seats_data" => selected_seats_data,
    },
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

          %{seat: Seats.get_seat_with_ticket!(id), row: row}
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

  defp page_title(:tickets), do: "Tickets"
end
