defmodule Postandcomment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PostandcommentWeb.Telemetry,
      # Start the Ecto repository
      Postandcomment.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Postandcomment.PubSub},
      # Start Finch
      {Finch, name: Postandcomment.Finch},
      # Start the Endpoint (http/https)
      PostandcommentWeb.Endpoint
      # Start a worker by calling: Postandcomment.Worker.start_link(arg)
      # {Postandcomment.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Postandcomment.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PostandcommentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
