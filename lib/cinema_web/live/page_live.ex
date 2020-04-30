defmodule CinemaWeb.PageLive do
  use CinemaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
