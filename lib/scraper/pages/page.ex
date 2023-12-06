defmodule Scraper.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :url, :string
    field :name, :string
    field :status, Ecto.Enum, values: [:none, :error, :done], default: :none

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:name, :url, :status])
    |> validate_required([:name, :url])
    |> validate_url()
  end

  defp validate_url(changeset) do
    validate_change(changeset, :url, fn :url, url ->
      if valid_url?(url) do
        []
      else
        [url: {"invalid url", additional: "make sure you have a https link"}]
      end
    end)
  end

  defp valid_url?(url) do
    uri = URI.parse(url)
    uri.scheme != nil && uri.host && uri.host =~ "."
  end
end
