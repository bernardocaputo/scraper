defmodule Scraper.PagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scraper.Pages` context.
  """

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Scraper.Pages.create_page()

    page
  end
end
