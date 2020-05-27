defmodule Cinema.Repo.Migrations.CreateHalls do
  use Ecto.Migration

  def change do
    create table(:halls) do
      add :number, :integer
      add :seats_count, :integer

      timestamps()
    end
  end
end
