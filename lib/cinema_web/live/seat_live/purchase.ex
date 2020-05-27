defmodule CinemaWeb.SeatLive.Purchase do
  use CinemaWeb, :live_view

  alias Cinema.Repo
  alias Cinema.Purchases.Purchase

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    purchase = Purchase |> Repo.get!(id) |> Repo.preload([:tickets])
    tickets = Enum.map(purchase.tickets, &Repo.preload(&1, seat: :hall))

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:purchase, purchase)
      |> assign(:tickets, tickets)
    }
  end

  defp page_title(:purchase), do: "Purchase"
end
