ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Scraper.Repo, :manual)

Mox.defmock(Scraper.HttpServerMock, for: ScraperWeb.HttpClient)
Application.put_env(:scraper, :http, Scraper.HttpServerMock)
