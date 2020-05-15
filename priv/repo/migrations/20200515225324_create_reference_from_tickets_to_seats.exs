defmodule Cinema.Repo.Migrations.CreateReferenceFromTicketsToSeats do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :seat_id, references(:seats)
    end
  end
end
