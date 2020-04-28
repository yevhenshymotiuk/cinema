defmodule Cinema.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do

      timestamps()
    end

  end
end
