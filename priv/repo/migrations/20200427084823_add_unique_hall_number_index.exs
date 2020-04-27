defmodule Cinema.Repo.Migrations.AddUniqueHallNumberIndex do
  use Ecto.Migration

  def change do
    create unique_index(:halls, [:number])
  end
end
