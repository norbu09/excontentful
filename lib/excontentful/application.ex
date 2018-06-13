defmodule Excontentful.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Excontentful.Supervisor]
    Supervisor.start_link([
      {ConCache, [
        ttl_check_interval: :timer.seconds(1),
        global_ttl: :timer.minutes(5),
        name: :content]}
    ], 
    opts)
  end
end
