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
               {"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
               {"a", [{"href", "http://github.com/philss/floki"}],
                [{"span", [{"data-model", "user"}], ["philss"]}]}
             ] == LinkFinder.find_links(page)
    end
  end
end
