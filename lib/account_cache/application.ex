defmodule AccountCache.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AccountCache.Repo,
      # Start the Telemetry supervisor
      AccountCacheWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AccountCache.PubSub},
      # Start the Endpoint (http/https)
      AccountCacheWeb.Endpoint,
      # Start a worker by calling: AccountCache.Worker.start_link(arg)
      # {AccountCache.Worker, arg}
      AccountCache.Customer.TrafficGenerator
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AccountCache.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AccountCacheWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
