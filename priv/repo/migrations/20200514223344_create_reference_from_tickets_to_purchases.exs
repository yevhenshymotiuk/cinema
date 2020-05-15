defmodule Cinema.Repo.Migrations.CreateReferenceFromTicketsToPurchases do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :purchase_id, references(:purchases, type: :binary_id)
    end
  end
end
