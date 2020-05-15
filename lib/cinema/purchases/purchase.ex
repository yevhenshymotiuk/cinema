defmodule Cinema.Purchases.Purchase do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "purchases" do
    has_many :tickets, Cinema.Tickets.Ticket

    timestamps()
  end

  @doc false
  def changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [])
    |> validate_required([])
  end
end
