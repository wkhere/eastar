defmodule Astar.Vger.Bench do
  use Benchfella

  defp setup do
    :vger_map.setup
    {env, start, goal, _} = :vger_map.well_known_path
    [env, start, goal]
  end

  bench "vger well known path using Eastar", [params: setup] do
    apply &Astar.astar/3, params
  end

  bench "vger well known path using Erlang ver", [params: setup] do
    apply &:vger_map.astar/3, params
  end
end
