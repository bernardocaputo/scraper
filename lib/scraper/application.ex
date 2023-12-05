defmodule Scraper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ScraperWeb.Telemetry,
      # Start the Ecto repository
      Scraper.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Scraper.PubSub},
      # Start Finch
      {Finch, name: Scraper.Finch},
      # Start the Endpoint (http/https)
      ScraperWeb.Endpoint
      # Start a worker by calling: Scraper.Worker.start_link(arg)
      # {Scraper.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScraperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
