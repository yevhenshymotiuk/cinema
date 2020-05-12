defmodule Cinema.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :uuid, :binary_id

    belongs_to :seat, Cinema.Seats.Seat

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [])
    |> validate_required([])
  end
end
