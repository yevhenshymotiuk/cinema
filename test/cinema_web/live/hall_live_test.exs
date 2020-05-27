defmodule CinemaWeb.HallLiveTest do
  use CinemaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Cinema.Lobby

  @create_attrs %{number: 42, seats_count: 42}
  @update_attrs %{number: 43, seats_count: 43}
  @invalid_attrs %{number: nil, seats_count: nil}

  defp fixture(:hall) do
    {:ok, hall} = Lobby.create_hall(@create_attrs)
    hall
  end

  defp create_hall(_) do
    hall = fixture(:hall)
    %{hall: hall}
  end

  describe "Index" do
    setup [:create_hall]

    test "lists all halls", %{conn: conn, hall: hall} do
      {:ok, _index_live, html} = live(conn, Routes.hall_index_path(conn, :index))

      assert html =~ "Listing Halls"
    end

    test "saves new hall", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.hall_index_path(conn, :index))

      assert index_live |> element("a", "New Hall") |> render_click() =~
               "New Hall"

      assert_patch(index_live, Routes.hall_index_path(conn, :new))

      assert index_live
             |> form("#hall-form", hall: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#hall-form", hall: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.hall_index_path(conn, :index))

      assert html =~ "Hall created successfully"
    end

    test "updates hall in listing", %{conn: conn, hall: hall} do
      {:ok, index_live, _html} = live(conn, Routes.hall_index_path(conn, :index))

      assert index_live |> element("#hall-#{hall.id} a", "Edit") |> render_click() =~
               "Edit Hall"

      assert_patch(index_live, Routes.hall_index_path(conn, :edit, hall))

      assert index_live
             |> form("#hall-form", hall: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#hall-form", hall: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.hall_index_path(conn, :index))

      assert html =~ "Hall updated successfully"
    end

    test "deletes hall in listing", %{conn: conn, hall: hall} do
      {:ok, index_live, _html} = live(conn, Routes.hall_index_path(conn, :index))

      assert index_live |> element("#hall-#{hall.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#hall-#{hall.id}")
    end
  end

  describe "Show" do
    setup [:create_hall]

    test "displays hall", %{conn: conn, hall: hall} do
      {:ok, _show_live, html} = live(conn, Routes.hall_show_path(conn, :show, hall))

      assert html =~ "Show Hall"
    end

    test "updates hall within modal", %{conn: conn, hall: hall} do
      {:ok, show_live, _html} = live(conn, Routes.hall_show_path(conn, :show, hall))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Hall"

      assert_patch(show_live, Routes.hall_show_path(conn, :edit, hall))

      assert show_live
             |> form("#hall-form", hall: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#hall-form", hall: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.hall_show_path(conn, :show, hall))

      assert html =~ "Hall updated successfully"
    end
  end
end
