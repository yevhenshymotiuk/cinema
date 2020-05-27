defmodule CinemaWeb.SeatLive.Selected do
  use CinemaWeb, :live_view

  alias Cinema.{Repo, Halls, Seats}
  alias Cinema.Purchases.Purchase
  alias Cinema.Timer
  alias SendGrid.{Email, Mail}
  alias CinemaWeb.SeatLive.SeatsComponent
  alias CinemaWeb.SeatLive.Index

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, email: "", ip: Index.get_ip(socket))}
  end

  @impl true
  def handle_params(
        %{"hall_id" => hall_id, "selected_seats_data" => selected_seats_data},
        _,
        socket
      ) do
    ip = socket.assigns.ip
    hall = Halls.get_hall!(hall_id)

    selected_seats_data =
      selected_seats_data
      |> decode()
      |> Enum.sort_by(& &1.seat.number)

    reserved =
      Enum.all?(
        selected_seats_data,
        &(is_nil(&1.seat.ticket) and not is_nil(&1.seat.reservation_ip))
      )

    sold =
      Enum.all?(
        selected_seats_data,
        &(not is_nil(&1.seat.ticket))
      )

    free = not reserved and not sold

    {selected_seats_data, socket} =
      if free do
        selected_seats_data =
          Enum.map(
            selected_seats_data,
            fn %{seat: seat, row: row} ->
              %{
                seat:
                  Seats.update_seat!(
                    seat,
                    %{reservation_ip: ip}
                  ),
                row: row
              }
            end
          )

        self = self()

        {:ok, timer} =
          Timer.start(
            seconds: 10,
            callback: fn ->
              seats =
                Enum.map(
                  selected_seats_data,
                  &Seats.update_seat!(&1.seat, %{reservation_ip: nil})
                )

              Process.send(self, {:cancel_reservation, seats}, [])
            end
          )

        {selected_seats_data, assign(socket, timer: timer)}
      else
        {selected_seats_data, socket}
      end

    reserved_user =
      Enum.all?(
        selected_seats_data,
        &(&1.seat.reservation_ip == ip)
      )

    {
      :noreply,
      socket
      |> assign(page_title: page_title(socket.assigns.live_action))
      |> assign(hall: hall)
      |> assign(selected_seats_data: selected_seats_data)
      |> assign(ip: ip)
      |> assign(reserved: reserved)
      |> assign(reserved_user: reserved_user)
      |> assign(free: free)
      |> assign(sold: sold)
    }
  end

  @impl true
  def handle_event("buy-tickets", _, socket) do
    Timer.stop(socket.assigns.timer)

    selected_seats_data = socket.assigns.selected_seats_data

    purchase = %Purchase{} |> Purchase.changeset(%{}) |> Repo.insert!()

    tickets =
      Enum.map(
        selected_seats_data,
        fn %{seat: seat, row: row_number} ->
          seat
          |> Seats.create_ticket!(
            purchase,
            %{row_number: String.to_integer(row_number)}
          )
          |> Repo.preload(seat: [:hall])
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
            to:
              Routes.seat_purchase_path(
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

  @impl true
  def handle_info({:cancel_reservation, seats}, socket) do
    hall_id = socket.assigns.hall.id

    {
      :noreply,
      socket
      |> push_redirect(
        to:
          Routes.seat_index_path(
            socket,
            :index,
            hall_id
          )
      )
      |> put_flash(:info, "Reservation time has expired!")
    }
  end

  defp page_title(:selected), do: "Selected seats"

  def encode(selected_seats) do
    selected_seats
    |> Enum.map(&"#{&1.id}|#{SeatsComponent.row(&1.number)}")
    |> Enum.join(",")
  end

  def decode(selected_seats_data) do
    selected_seats_data
    |> String.split(",")
    |> Enum.map(fn x ->
      [id, row] = String.split(x, "|")

      %{
        seat: id |> Seats.get_seat!() |> Repo.preload([:ticket]),
        row: row
      }
    end)
  end
end
