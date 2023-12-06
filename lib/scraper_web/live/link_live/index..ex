defmodule ScraperWeb.LinkLive.Index do
  use ScraperWeb, :live_view

  alias Scraper.Links

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Links
    </.header>

    <.table id="links" rows={@links}>
      <:col :let={link} label="Name"><%= link.body %></:col>

      <:col :let={link} label="Url"><%= link.url %></:col>
    </.table>

    <.back navigate={~p"/pages"}>Back to pages</.back>
    """
  end

  @impl true
  def mount(%{"page_id" => page_id}, _session, socket) do
    {:ok, assign(socket, :links, Links.list_links_by_page_id(page_id)),
     temporary_assigns: [links: []]}
  end
end
