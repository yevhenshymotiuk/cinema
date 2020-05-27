defmodule Cinema.Repo.Migrations.AddReservationIpFieldToSeatsTable do
  use Ecto.Migration

  def change do
    alter table(:seats) do
      add :reservation_ip, :string
    end
  end
end
