defmodule Cinema.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :row_number, :integer

      timestamps()
    end
  end
end
