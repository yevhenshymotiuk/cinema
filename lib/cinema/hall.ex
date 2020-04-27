defmodule Cinema.Hall do
  @moduledoc """
  The Hall context.
  """

  import Ecto.Query, warn: false
  alias Cinema.Repo

  alias Cinema.Hall.Seat

  @doc """
  Returns the list of seats.

  ## Examples

      iex> list_seats()
      [%Seat{}, ...]

  """
  def list_seats(hall_id) do
    Repo.all(from s in Seat, where: s.hall_id == ^String.to_integer(hall_id), select: s)
  end

  @doc """
  Gets a single seat.

  Raises `Ecto.NoResultsError` if the Seat does not exist.

  ## Examples

      iex> get_seat!(123)
      %Seat{}

      iex> get_seat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_seat!(id), do: Repo.get!(Seat, id)

  @doc """
  Creates a seat.

  ## Examples

      iex> create_seat(%{field: value})
      {:ok, %Seat{}}

      iex> create_seat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_seat(attrs \\ %{}, hall) do
    %Seat{}
    |> Seat.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:hall, hall)
    |> Repo.insert()
  end

  @doc """
  Updates a seat.

  ## Examples

      iex> update_seat(seat, %{field: new_value})
      {:ok, %Seat{}}

      iex> update_seat(seat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_seat(%Seat{} = seat, attrs) do
    seat
    |> Seat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a seat.

  ## Examples

      iex> delete_seat(seat)
      {:ok, %Seat{}}

      iex> delete_seat(seat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_seat(%Seat{} = seat) do
    Repo.delete(seat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking seat changes.

  ## Examples

      iex> change_seat(seat)
      %Ecto.Changeset{data: %Seat{}}

  """
  def change_seat(%Seat{} = seat, attrs \\ %{}) do
    Seat.changeset(seat, attrs)
  end
end
