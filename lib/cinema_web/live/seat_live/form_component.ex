defmodule CinemaWeb.SeatLive.FormComponent do
  use CinemaWeb, :live_component

  alias Cinema.Seats

  @impl true
  def update(%{seat: seat} = assigns, socket) do
    changeset = Seats.change_seat(seat)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"seat" => seat_params}, socket) do
    changeset =
      socket.assigns.seat
      |> Seats.change_seat(seat_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"seat" => seat_params}, socket) do
    save_seat(socket, socket.assigns.action, seat_params)
  end

  defp save_seat(socket, :edit, seat_params) do
    case Seats.update_seat(socket.assigns.seat, seat_params) do
      {:ok, _seat} ->
        {:noreply,
         socket
         |> put_flash(:info, "Seat updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_seat(socket, :new, seat_params) do
    case Seats.create_seat(seat_params, socket.assigns.hall) do
      {:ok, _seat} ->
        {:noreply,
         socket
         |> put_flash(:info, "Seat created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
