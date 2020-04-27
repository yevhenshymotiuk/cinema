defmodule Cinema.HallTest do
  use Cinema.DataCase

  alias Cinema.Hall

  describe "seats" do
    alias Cinema.Hall.Seat

    @valid_attrs %{number: 42}
    @update_attrs %{number: 43}
    @invalid_attrs %{number: nil}

    def seat_fixture(attrs \\ %{}) do
      {:ok, seat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Hall.create_seat()

      seat
    end

    test "list_seats/0 returns all seats" do
      seat = seat_fixture()
      assert Hall.list_seats() == [seat]
    end

    test "get_seat!/1 returns the seat with given id" do
      seat = seat_fixture()
      assert Hall.get_seat!(seat.id) == seat
    end

    test "create_seat/1 with valid data creates a seat" do
      assert {:ok, %Seat{} = seat} = Hall.create_seat(@valid_attrs)
      assert seat.number == 42
    end

    test "create_seat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hall.create_seat(@invalid_attrs)
    end

    test "update_seat/2 with valid data updates the seat" do
      seat = seat_fixture()
      assert {:ok, %Seat{} = seat} = Hall.update_seat(seat, @update_attrs)
      assert seat.number == 43
    end

    test "update_seat/2 with invalid data returns error changeset" do
      seat = seat_fixture()
      assert {:error, %Ecto.Changeset{}} = Hall.update_seat(seat, @invalid_attrs)
      assert seat == Hall.get_seat!(seat.id)
    end

    test "delete_seat/1 deletes the seat" do
      seat = seat_fixture()
      assert {:ok, %Seat{}} = Hall.delete_seat(seat)
      assert_raise Ecto.NoResultsError, fn -> Hall.get_seat!(seat.id) end
    end

    test "change_seat/1 returns a seat changeset" do
      seat = seat_fixture()
      assert %Ecto.Changeset{} = Hall.change_seat(seat)
    end
  end

  describe "seats" do
    alias Cinema.Hall.Hall.Seat

    @valid_attrs %{number: 42}
    @update_attrs %{number: 43}
    @invalid_attrs %{number: nil}

    def seat_fixture(attrs \\ %{}) do
      {:ok, seat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Hall.create_seat()

      seat
    end

    test "list_seats/0 returns all seats" do
      seat = seat_fixture()
      assert Hall.list_seats() == [seat]
    end

    test "get_seat!/1 returns the seat with given id" do
      seat = seat_fixture()
      assert Hall.get_seat!(seat.id) == seat
    end

    test "create_seat/1 with valid data creates a seat" do
      assert {:ok, %Seat{} = seat} = Hall.create_seat(@valid_attrs)
      assert seat.number == 42
    end

    test "create_seat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hall.create_seat(@invalid_attrs)
    end

    test "update_seat/2 with valid data updates the seat" do
      seat = seat_fixture()
      assert {:ok, %Seat{} = seat} = Hall.update_seat(seat, @update_attrs)
      assert seat.number == 43
    end

    test "update_seat/2 with invalid data returns error changeset" do
      seat = seat_fixture()
      assert {:error, %Ecto.Changeset{}} = Hall.update_seat(seat, @invalid_attrs)
      assert seat == Hall.get_seat!(seat.id)
    end

    test "delete_seat/1 deletes the seat" do
      seat = seat_fixture()
      assert {:ok, %Seat{}} = Hall.delete_seat(seat)
      assert_raise Ecto.NoResultsError, fn -> Hall.get_seat!(seat.id) end
    end

    test "change_seat/1 returns a seat changeset" do
      seat = seat_fixture()
      assert %Ecto.Changeset{} = Hall.change_seat(seat)
    end
  end
end
