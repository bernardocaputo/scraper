defmodule Scraper.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scraper.Links` context.
  """

  alias Scraper.PagesFixtures

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        body: "some body",
        url: "some url",
        page_id: PagesFixtures.page_fixture().id
      })
      |> Scraper.Links.create_link()

    link
  end
end
