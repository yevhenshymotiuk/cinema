defmodule Cinema.Repo.Migrations.CreateSeatsUniqueIndexNumberHallId do
  use Ecto.Migration

  def change do
    create unique_index(:seats, [:number, :hall_id])
  end
end
