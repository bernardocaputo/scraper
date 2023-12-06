defmodule Scraper.LinksTest do
  use Scraper.DataCase

  alias Scraper.Links

  describe "links" do
    alias Scraper.Links.Link

    import Scraper.LinksFixtures
    import Scraper.PagesFixtures

    @invalid_attrs %{body: nil, url: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "list_links_by_page_id/1 returns all links by page_id" do
      link = link_fixture()
      assert Links.list_links_by_page_id(link.page_id) == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{
        body: "some body",
        url: "some url",
        page_id: page_fixture().id
      }

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.body == "some body"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "create_link/1 missing page_id returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(%{body: "body", url: "url"})
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      update_attrs = %{body: "some updated body", url: "some updated url"}

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)
      assert link.body == "some updated body"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end

    test "validate_and_insert/2 validate and insert_all" do
      params = [
        {"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
        {"a", [{"href", "http://github.com/philss/floki"}],
         [{"span", [{"data-model", "user"}], ["philss"]}]},
        {"a", [{"src", "http://github.com/philss/floki"}],
         [{"span", [{"data-model", "user"}], ["philss"]}]}
      ]

      page = page_fixture()
      assert {3, nil} == Links.validate_and_insert(params, page)
    end
  end
end
