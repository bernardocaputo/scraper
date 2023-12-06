defmodule Scraper.LinkFinder do
  alias ScraperWeb.HttpClient

  @doc """
  Find all links in a web page and prepare its params
  """
  @spec find_links(url :: binary(), page :: Scraper.Pages.Page.t()) :: [map()]
  def find_links(url, page) do
    with {:ok, %{body: html}} <- HttpClient.get(url),
         {:ok, document} <- Floki.parse_document(html) do
      document
      |> Floki.find("a")
      |> prepare_params(page)
    end
  end

  defp prepare_params(params, page) do
    Enum.map(params, fn {"a", _attributes, body} = x ->
      [url] = Floki.attribute(x, "href")
      %{url: url, body: prepare_body(body), page_id: page.id}
    end)
  end

  defp prepare_body([body]) when is_binary(body), do: body
  defp prepare_body(body), do: Floki.raw_html(body)
end
