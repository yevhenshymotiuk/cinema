defmodule CinemaWeb.HallLive.FormComponent do
  use CinemaWeb, :live_component

  alias Cinema.Halls

  @impl true
  def update(%{hall: hall} = assigns, socket) do
    changeset = Halls.change_hall(hall)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"hall" => hall_params}, socket) do
    changeset =
      socket.assigns.hall
      |> Halls.change_hall(hall_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"hall" => hall_params}, socket) do
    save_hall(socket, socket.assigns.action, hall_params)
  end

  defp save_hall(socket, :edit, hall_params) do
    case Halls.update_hall(socket.assigns.hall, hall_params) do
      {:ok, _hall} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hall updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_hall(socket, :new, hall_params) do
    case Halls.create_hall(hall_params) do
      {:ok, _hall} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hall created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
