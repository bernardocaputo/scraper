defmodule Scraper.Repo.Migrations.AddStatusToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :status, :string, null: false
      add :url, :string
    end
  end
end
