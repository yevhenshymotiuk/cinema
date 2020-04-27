defmodule Cinema.Repo do
  use Ecto.Repo,
    otp_app: :cinema,
    adapter: Ecto.Adapters.Postgres
end
