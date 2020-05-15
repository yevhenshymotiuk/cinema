defmodule CinemaWeb.SeatLive.Selected do
  use CinemaWeb, :live_view

  alias Cinema.{Repo, Halls, Seats}
  alias Cinema.Purchases.Purchase

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

    purchase = %Purchase{} |> Purchase.changeset(%{}) |> Repo.insert!()

    Enum.each(
      selected_seats_data,
      fn %{seat: seat, row: row_number} ->
        Seats.create_ticket!(
          seat,
          purchase,
          %{row_number: String.to_integer(row_number)}
        )
      end
    )

    {
      :noreply,
      socket
      |> push_redirect(
        to: Routes.seat_purchases_path(
          socket,
          :purchases,
          purchase.id
        )
      )
      |> put_flash(:info, "Tickets were successfully bought")
    }
  end

  defp page_title(:selected), do: "Selected seats"
end
