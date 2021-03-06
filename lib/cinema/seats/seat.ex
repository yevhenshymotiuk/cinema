defmodule Cinema.Seats.Seat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "seats" do
    field :number, :integer, default: 1
    field :reservation_ip, :string

    belongs_to :hall, Cinema.Halls.Hall
    has_one :ticket, Cinema.Tickets.Ticket

    timestamps()
  end

  @doc false
  def changeset(seat, attrs) do
    seat
    |> cast(attrs, [:number, :reservation_ip])
    |> validate_required([:number])
    |> unique_constraint([:number, :hall])
    |> validate_number(:number, greater_than: 0)
  end
end
