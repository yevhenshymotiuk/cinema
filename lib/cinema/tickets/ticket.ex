defmodule Cinema.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tickets" do
    belongs_to :seat, Cinema.Seats.Seat
    belongs_to :purchase, Cinema.Purchases.Purchase, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [])
    |> validate_required([])
  end
end
