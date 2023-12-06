defmodule Scraper.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Scraper.Repo

  alias Scraper.Links.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  @doc """
  Returns the list of links by page id.

  ## Examples

      iex> list_links_by_page_id(1)
      [%Link{}, ...]

  """
  def list_links_by_page_id(page_id) do
    Link
    |> where([l], l.page_id == ^page_id)
    |> Repo.all()
  end

  @doc """
  Prepare params, validate and insert data
  """
  @spec validate_and_insert(params :: list(tuple()), Scraper.Pages.Page.t()) ::
          {integer(), nil} | {:error, Ecto.Changeset.t()}
  def validate_and_insert({:error, _reason} = err, _page), do: err

  def validate_and_insert(params, page) do
    params
    |> prepare_params(page)
    |> validate_and_insert_data()
  end

  defp prepare_params(params, page) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    Enum.reduce_while(params, [], fn {"a", _attributes, body} = x, acc ->
      params = %{
        url: fetch_attribute(x, "href"),
        body: prepare_body(body),
        page_id: page.id,
        inserted_at: now,
        updated_at: now
      }

      changeset = change_link(%Link{}, params)

      if changeset.valid? do
        {:cont, acc ++ [params]}
      else
        {:halt, {:error, changeset}}
      end
    end)
  end

  defp fetch_attribute(x, attr) do
    try do
      [url] = Floki.attribute(x, attr)
      url
    rescue
      _ -> "no href attribute"
    end
  end

  defp validate_and_insert_data({:error, _reason} = err), do: err

  defp validate_and_insert_data(maps) do
    Repo.insert_all(Link, maps)
  end

  defp prepare_body([raw]) when is_binary(raw) do
    Enum.join(for <<c::utf8 <- raw>>, do: <<c::utf8>>)
  end

  defp prepare_body(body) do
    Floki.raw_html(body) |> String.slice(0..50)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end
end
