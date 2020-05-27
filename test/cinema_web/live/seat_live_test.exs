defmodule CinemaWeb.SeatLiveTest do
  use CinemaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Cinema.Hall

  @create_attrs %{number: 42}
  @update_attrs %{number: 43}
  @invalid_attrs %{number: nil}

  defp fixture(:seat) do
    {:ok, seat} = Hall.create_seat(@create_attrs)
    seat
  end

  defp create_seat(_) do
    seat = fixture(:seat)
    %{seat: seat}
  end

  describe "Index" do
    setup [:create_seat]

    test "lists all seats", %{conn: conn, seat: seat} do
      {:ok, _index_live, html} = live(conn, Routes.seat_index_path(conn, :index))

      assert html =~ "Listing Seats"
    end

    test "saves new seat", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.seat_index_path(conn, :index))

      assert index_live |> element("a", "New Seat") |> render_click() =~
               "New Seat"

      assert_patch(index_live, Routes.seat_index_path(conn, :new))

      assert index_live
             |> form("#seat-form", seat: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#seat-form", seat: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.seat_index_path(conn, :index))

      assert html =~ "Seat created successfully"
    end

    test "updates seat in listing", %{conn: conn, seat: seat} do
      {:ok, index_live, _html} = live(conn, Routes.seat_index_path(conn, :index))

      assert index_live |> element("#seat-#{seat.id} a", "Edit") |> render_click() =~
               "Edit Seat"

      assert_patch(index_live, Routes.seat_index_path(conn, :edit, seat))

      assert index_live
             |> form("#seat-form", seat: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#seat-form", seat: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.seat_index_path(conn, :index))

      assert html =~ "Seat updated successfully"
    end

    test "deletes seat in listing", %{conn: conn, seat: seat} do
      {:ok, index_live, _html} = live(conn, Routes.seat_index_path(conn, :index))

      assert index_live |> element("#seat-#{seat.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#seat-#{seat.id}")
    end
  end

  describe "Show" do
    setup [:create_seat]

    test "displays seat", %{conn: conn, seat: seat} do
      {:ok, _show_live, html} = live(conn, Routes.seat_show_path(conn, :show, seat))

      assert html =~ "Show Seat"
    end

    test "updates seat within modal", %{conn: conn, seat: seat} do
      {:ok, show_live, _html} = live(conn, Routes.seat_show_path(conn, :show, seat))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Seat"

      assert_patch(show_live, Routes.seat_show_path(conn, :edit, seat))

      assert show_live
             |> form("#seat-form", seat: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#seat-form", seat: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.seat_show_path(conn, :show, seat))

      assert html =~ "Seat updated successfully"
    end
  end
end
