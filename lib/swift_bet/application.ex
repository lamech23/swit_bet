defmodule SwiftBet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SwiftBetWeb.Telemetry,
      SwiftBet.Repo,
      {DNSCluster, query: Application.get_env(:swift_bet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SwiftBet.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SwiftBet.Finch},
      # Start a worker by calling: SwiftBet.Worker.start_link(arg)
      # {SwiftBet.Worker, arg},
      # Start to serve requests, typically the last entry
      {Oban, oban_config()},
      SwiftBetWeb.Endpoint

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SwiftBet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SwiftBetWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config() do
    Application.fetch_env!(:swift_bet, Oban)
  end
end
