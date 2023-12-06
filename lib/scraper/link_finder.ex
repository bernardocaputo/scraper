defmodule Scraper.LinkFinder do
  alias ScraperWeb.HttpClient

  @doc """
  Find all links in a web page
  """
  @spec find_links(page :: Scraper.Pages.Page.t()) :: [map()]
  def find_links(page) do
    with {:ok, %{body: html}} <- HttpClient.get(page.url),
         {:ok, document} <- Floki.parse_document(html) do
      document
      |> Floki.find("a")
    end
  end
end
