defmodule Scraper.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
