defmodule ScraperWeb.HttpClient do
  @callback get(binary()) :: {:ok, HTTPoison.Response.t()}

  def get(url) do
    impl().get(url)
  end

  defp impl(), do: Application.get_env(:scraper, :http, HTTPoison)
end
