defmodule Scraper.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scraper.Pages.Page

  schema "links" do
    field :body, :string
    field :url, :string

    belongs_to :page, Page

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:body, :url, :page_id])
    |> validate_required([:url, :page_id])
    |> foreign_key_constraint(:page_id)
  end
end
