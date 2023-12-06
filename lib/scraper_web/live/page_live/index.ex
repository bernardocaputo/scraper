defmodule ScraperWeb.PageLive.Index do
  use ScraperWeb, :live_view

  alias Scraper.Pages
  alias Scraper.Pages.Page
  alias Scraper.LinkFinder
  alias Scraper.Links

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :pages, Pages.list_pages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Page")
    |> assign(:page, Pages.get_page!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Scraper")
    |> assign(:page, %Page{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pages")
    |> assign(:page, nil)
  end

  @impl true
  def handle_info({ScraperWeb.PageLive.FormComponent, {:saved, page}}, socket) do
    fetch_data(page)

    {:noreply, stream_insert(socket, :pages, page, at: 0)}
  end

  def handle_info({:find_links, page, result}, socket) do
    case Pages.update_page(page, %{status: processed_value(result)}) do
      {:ok, page} ->
        {:noreply, stream_insert(socket, :pages, page, at: 0)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Error updating status")}
    end
  end

  defp fetch_data(page) do
    parent_pid = self()

    Task.start_link(fn ->
      result = LinkFinder.find_links(page) |> Links.validate_and_insert(page)
      send(parent_pid, {:find_links, page, result})
    end)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    page = Pages.get_page!(id)
    {:ok, _} = Pages.delete_page(page)

    {:noreply, stream_delete(socket, :pages, page)}
  end

  def handle_processed_style(assigns) do
    {color, msg} = color_and_message(assigns.page.status)
    assigns = assigns |> assign(:color, color) |> assign(:message, msg)

    ~H"""
    <span style={"background-color: #{@color};"}>
      <%= "#{@message}" %>
    </span>
    """
  end

  defp processed_value({_, nil}), do: "done"
  defp processed_value(_), do: "error"

  defp color_and_message(:done), do: {"green", "done"}
  defp color_and_message(:none), do: {"yellow", "processing..."}
  defp color_and_message(:error), do: {"red", "error"}
end
