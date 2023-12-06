defmodule Scraper.LinkFinderTest do
  use Scraper.DataCase

  alias Scraper.LinkFinder
  alias Scraper.HttpServerMock

  import Scraper.PagesFixtures
  import Mox

  describe "find_links/2" do
    test "list_links/0 returns all links" do
      HttpServerMock
      |> expect(:get, fn _url ->
        {:ok,
         %{
           body: """
           <!doctype html>
           <html>
           <body>
           <section id="content">
           <p class="headline">Floki</p>
           <a href="http://github.com/philss/floki">Github page</a>
           <a href="http://github.com/philss/floki"><span data-model="user">philss</span></a>
           <span data-model="user">philss</span>
           </section>
           </body>
           </html>
           """
         }}
      end)

      page = page_fixture()

      assert [
               %{body: "Github page", page_id: page.id, url: "http://github.com/philss/floki"},
               %{
                 body: "<span data-model=\"user\">philss</span>",
                 page_id: page.id,
                 url: "http://github.com/philss/floki"
               }
             ] == LinkFinder.find_links("https://wwww.globo.com", page)
    end
  end
end
