defmodule CinemaWeb.SeatLive.Selected do
  use CinemaWeb, :live_view

  alias Cinema.{Repo, Halls, Seats}
  alias Cinema.Purchases.Purchase
  alias SendGrid.{Email, Mail}
  alias CinemaWeb.SeatLive.SeatsComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, email: "")}
  end

  @impl true
  def handle_params(
    %{"hall_id" => hall_id, "selected_seats_data" => selected_seats_data},
    _,
    socket
  ) do
    hall = Halls.get_hall!(hall_id)

    IO.puts(socket.assigns.email)

    selected_seats_data =
      selected_seats_data
      |> decode()
      |> Enum.sort_by(& &1.seat.number)

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

    tickets = Enum.map(
      selected_seats_data,
      fn %{seat: seat, row: row_number} ->
        seat
        |> Seats.create_ticket!(
          purchase,
          %{row_number: String.to_integer(row_number)}
        )
        |> Repo.preload([seat: :hall])
      end
    )

    mail =
      Email.build()
      |> Email.add_to(socket.assigns.email)
      |> Email.put_from("cinema@email")
      |> Email.put_subject("Tickets purchase")
      |> Email.put_phoenix_view(CinemaWeb.PurchaseView)
      |> Email.put_phoenix_template(
        "purchase.html",
        socket: socket,
        tickets: tickets
      )

    case Mail.send(mail) do
      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Email can't be sent. Check your address")}
      :ok ->
        {
          :noreply,
          socket
          |> push_redirect(
            to: Routes.seat_purchase_path(
              socket,
              :purchase,
              purchase.id
            )
          )
          |> put_flash(:info, "Tickets were successfully bought")
        }
    end
  end

  def handle_event("email-form-changed", %{"email" => email}, socket) do
    {:noreply, assign(socket, email: email)}
  end

  defp page_title(:selected), do: "Selected seats"

  def encode(selected_seats) do
    selected_seats
    |> Enum.map(& "#{&1.id}|#{SeatsComponent.row(&1.number)}")
    |> Enum.join(",")
  end

  def decode(selected_seats_data) do
    selected_seats_data
    |> String.split(",")
    |> Enum.map(
      fn x ->
        [id, row] = String.split(x, "|")

        %{
          seat: id |> Seats.get_seat!() |> Repo.preload([:ticket]),
          row: row
        }
      end
    )
  end
end
