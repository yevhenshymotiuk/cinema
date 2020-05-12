defmodule Cinema.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"pgcrypto\";")

    create table(:tickets) do
      add :uuid, :uuid, default: fragment("gen_random_uuid()")

      timestamps()
    end

  end
end
