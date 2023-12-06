defmodule ScraperWeb.LinkLive.Index do
  use ScraperWeb, :live_view

  alias Scraper.Links

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Links
    </.header>

    <form phx-change="select-per-page" style="text-align: right;">
      <select name="per_page">
        <%= Phoenix.HTML.Form.options_for_select(
          [5, 10, 15, 20],
          @options.per_page
        ) %>
      </select>
      <label for="per_page">per page</label>
    </form>

    <.table id="links" rows={@links}>
      <:col :let={link} label="Name"><%= link.body %></:col>

      <:col :let={link} label="Url"><%= link.url %></:col>
    </.table>

    <div class="text-center bg-white max-w-5xl mx-auto text-lg py-8;">
      <.link
        :if={@options.page > 1}
        patch={~p"/pages/#{@page_id}/links?#{%{@options | page: @options.page - 1}}"}
      >
        PREVIOUS
      </.link>
      <.link
        :for={{page, current_page?} <- pages(@options, @links_count)}
        class={if current_page?, do: "bg-indigo-700 text-white"}
        patch={~p"/pages/#{@page_id}/links?#{%{@options | page: page}}"}
      >
        <%= page %>
      </.link>
      <.link
        :if={more_pages?(@options, @links_count)}
        patch={~p"/pages/#{@page_id}/links?#{%{@options | page: @options.page + 1}}"}
      >
        NEXT
      </.link>
    </div>

    <.back navigate={~p"/pages"}>Back to pages</.back>
    """
  end

  @impl true
  def mount(%{"page_id" => page_id}, _session, socket) do
    socket =
      socket
      |> assign(:page_id, page_id)
      |> assign(:links_count, Links.count_links(page_id))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    options = %{
      page: param_to_integer(params["page"], 1),
      per_page: param_to_integer(params["per_page"], 5)
    }

    socket = assign(socket, :options, options)

    {:noreply,
     assign(socket, :links, Links.list_links_by_page_id(socket.assigns.page_id, options))}
  end

  @impl true
  def handle_event("select-per-page", %{"per_page" => per_page}, socket) do
    options = %{socket.assigns.options | per_page: per_page}

    socket = push_patch(socket, to: ~p"/pages/#{socket.assigns.page_id}/links?#{options}")

    {:noreply, socket}
  end

  defp param_to_integer(nil, default), do: default

  defp param_to_integer(param, default) do
    case Integer.parse(param) do
      {number, _} ->
        number

      :error ->
        default
    end
  end

  defp more_pages?(options, link_count) do
    options.page * options.per_page < link_count
  end

  defp pages(options, link_count) do
    page_count = ceil(link_count / options.per_page)

    for page_number <- (options.page - 2)..(options.page + 2),
        page_number > 0 do
      if page_number <= page_count do
        current_page? = page_number == options.page
        {page_number, current_page?}
      end
    end
  end
end
