defmodule Cinema.LobbyTest do
  use Cinema.DataCase

  alias Cinema.Lobby

  describe "halls" do
    alias Cinema.Lobby.Hall

    @valid_attrs %{number: 42, seats_count: 42}
    @update_attrs %{number: 43, seats_count: 43}
    @invalid_attrs %{number: nil, seats_count: nil}

    def hall_fixture(attrs \\ %{}) do
      {:ok, hall} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lobby.create_hall()

      hall
    end

    test "list_halls/0 returns all halls" do
      hall = hall_fixture()
      assert Lobby.list_halls() == [hall]
    end

    test "get_hall!/1 returns the hall with given id" do
      hall = hall_fixture()
      assert Lobby.get_hall!(hall.id) == hall
    end

    test "create_hall/1 with valid data creates a hall" do
      assert {:ok, %Hall{} = hall} = Lobby.create_hall(@valid_attrs)
      assert hall.number == 42
      assert hall.seats_count == 42
    end

    test "create_hall/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lobby.create_hall(@invalid_attrs)
    end

    test "update_hall/2 with valid data updates the hall" do
      hall = hall_fixture()
      assert {:ok, %Hall{} = hall} = Lobby.update_hall(hall, @update_attrs)
      assert hall.number == 43
      assert hall.seats_count == 43
    end

    test "update_hall/2 with invalid data returns error changeset" do
      hall = hall_fixture()
      assert {:error, %Ecto.Changeset{}} = Lobby.update_hall(hall, @invalid_attrs)
      assert hall == Lobby.get_hall!(hall.id)
    end

    test "delete_hall/1 deletes the hall" do
      hall = hall_fixture()
      assert {:ok, %Hall{}} = Lobby.delete_hall(hall)
      assert_raise Ecto.NoResultsError, fn -> Lobby.get_hall!(hall.id) end
    end

    test "change_hall/1 returns a hall changeset" do
      hall = hall_fixture()
      assert %Ecto.Changeset{} = Lobby.change_hall(hall)
    end
  end
end
