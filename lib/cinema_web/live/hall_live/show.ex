defmodule CinemaWeb.HallLive.Show do
  use CinemaWeb, :live_view

  alias Cinema.Lobby

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:hall, Lobby.get_hall!(id))}
  end

  defp page_title(:show), do: "Show Hall"
  defp page_title(:edit), do: "Edit Hall"
end
