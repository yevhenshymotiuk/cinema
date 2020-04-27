defmodule CinemaWeb.HallLive.Index do
  use CinemaWeb, :live_view

  alias Cinema.Lobby
  alias Cinema.Lobby.Hall

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :halls, fetch_halls())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Hall")
    |> assign(:hall, Lobby.get_hall!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Hall")
    |> assign(:hall, %Hall{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Halls")
    |> assign(:hall, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    hall = Lobby.get_hall!(id)
    {:ok, _} = Lobby.delete_hall(hall)

    {:noreply, assign(socket, :halls, fetch_halls())}
  end

  defp fetch_halls do
    Lobby.list_halls()
  end
end
