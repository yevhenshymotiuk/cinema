defmodule Cinema.Lobby.Hall do
  use Ecto.Schema
  import Ecto.Changeset

  schema "halls" do
    field :number, :integer, default: 1
    field :seats_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(hall, attrs) do
    hall
    |> cast(attrs, [:number, :seats_count])
    |> unique_constraint(:number)
    |> validate_required([:number, :seats_count])
    |> validate_number(:number, greater_than: 0)
    |> validate_number(:seats_count, greater_than_or_equal_to: 0)
  end
end
