defmodule Cinema.Repo.Migrations.CreateSeats do
  use Ecto.Migration

  def change do
    create table(:seats) do
      add :number, :integer

      timestamps()
    end

    create unique_index(:seats, [:number])
  end
end
