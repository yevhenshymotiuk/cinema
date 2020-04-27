defmodule Cinema.Repo.Migrations.CreateReferenceFromSeatsToHalls do
  use Ecto.Migration

  def change do
    alter table(:seats) do
      add :hall_id, references("halls")
    end
  end
end
