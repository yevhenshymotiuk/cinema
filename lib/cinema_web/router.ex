defmodule CinemaWeb.Router do
  use CinemaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CinemaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CinemaWeb do
    pipe_through :browser

    live "/", HallLive.Index, :index
    live "/halls/new", HallLive.Index, :new
    live "/halls/:id/edit", HallLive.Index, :edit

    live "/halls/:id", HallLive.Show, :show
    live "/halls/:id/show/edit", HallLive.Show, :edit

    scope "/halls/:hall_id" do
      live "/seats", SeatLive.Index, :index
      live "/seats/new", SeatLive.Index, :new
      live "/seats/:id/edit", SeatLive.Index, :edit

      live "/seats/selected/:selected_seats_data", SeatLive.Selected, :selected
      live "/seats/:id/show/edit", SeatLive.Show, :edit
    end

    live "/purchases/:id", SeatLive.Purchase, :purchase

    live "/tickets", TicketLive.Index, :index
    live "/tickets/new", TicketLive.Index, :new
    live "/tickets/:id/edit", TicketLive.Index, :edit

    live "/tickets/:id", TicketLive.Show, :show
    live "/tickets/:id/show/edit", TicketLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", CinemaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CinemaWeb.Telemetry
    end
  end
end
