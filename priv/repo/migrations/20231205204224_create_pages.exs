defmodule Scraper.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :name, :string

      timestamps()
    end
  end
end
