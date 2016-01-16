defmodule Astar.App do
  use Application

  @moduledoc false

  def start(_type, _args) do
    kids = []
    # what can be done here: some kind of caching
    opts = [strategy: :one_for_one, name: Astar.Supervisor]
    Supervisor.start_link(kids, opts)
  end
end
