defmodule Cinema.Repo.Migrations.CreateSeats do
  use Ecto.Migration

  def change do
    create table(:seats) do
      add :number, :integer

      timestamps()
    end
  end
end
