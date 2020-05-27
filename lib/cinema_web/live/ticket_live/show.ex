defmodule CinemaWeb.TicketLive.Show do
  use CinemaWeb, :live_view

  alias Cinema.{Repo, Tickets}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    ticket =
      id
      |> Tickets.get_ticket!()
      |> Repo.preload(seat: :hall)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ticket, ticket)}
  end

  defp page_title(:show), do: "Show Ticket"
  defp page_title(:edit), do: "Edit Ticket"
end
