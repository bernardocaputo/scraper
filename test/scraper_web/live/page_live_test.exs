defmodule ScraperWeb.PageLiveTest do
  use ScraperWeb.ConnCase

  import Scraper.AccountsFixtures
  import Phoenix.LiveViewTest
  import Scraper.PagesFixtures

  @create_attrs %{name: "some name", url: "https://www.example.com"}
  @invalid_attrs %{name: nil}

  defp create_page(_) do
    page = page_fixture()
    %{page: page}
  end

  setup %{conn: conn} do
    %{conn: log_in_user(conn, user_fixture())}
  end

  describe "Index" do
    setup [:create_page]

    test "lists all pages", %{conn: conn, page: page} do
      {:ok, _index_live, html} = live(conn, ~p"/pages")

      assert html =~ "Listing Pages"
      assert html =~ page.name
    end

    test "saves new page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pages")

      assert index_live |> element("a", "New Scraper") |> render_click() =~ "New Scraper"

      assert_patch(index_live, ~p"/pages/new")

      assert index_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#page-form", page: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pages")

      html = render(index_live)
      assert html =~ "Page created successfully"
      assert html =~ "some name"
    end

    test "deletes page in listing", %{conn: conn, page: page} do
      {:ok, index_live, _html} = live(conn, ~p"/pages")

      assert index_live |> element("#pages-#{page.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pages-#{page.id}")
    end
  end
end
