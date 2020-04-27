defmodule Cinema.Hall.Seat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "seats" do
    field :number, :integer, default: 1

    belongs_to :hall, Cinema.Lobby.Hall

    timestamps()
  end

  @doc false
  def changeset(seat, attrs) do
    seat
    |> cast(attrs, [:number])
    |> validate_required([:number])
    |> unique_constraint(:number)
    |> validate_number(:number, greater_than: 0)
  end
end
