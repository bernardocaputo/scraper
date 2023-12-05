defmodule Scraper.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :body, :string
      add :url, :string
      add :page_id, references(:pages, on_delete: :delete_all)

      timestamps()
    end

    create index(:links, [:page_id])
  end
end
