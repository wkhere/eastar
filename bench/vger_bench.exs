defmodule Astar.Vger.Bench do
  use Benchfella

  defp setup do
    :vger_map.setup
    drive = :ion
    {
      &:vger_map.nb_memo/1,
      :vger_map.gen_dist(drive),
      :vger_map.gen_h(drive)
    }
  end

  bench "vger well known path", [env: setup] do
    Astar.astar(env, {:enioar,1,1}, {:enioar,20,7})
  end
end
