defmodule Astar.Vger.Test do
  use ExUnit.Case

  setup do
    :vger_map.setup
    drive = :ion
    env = {
      &:vger_map.nb_memo/1,
      :vger_map.gen_dist(drive),
      :vger_map.gen_h(drive)
    }
    sector = :enioar
    path = {
      {sector,1,1}, {sector,20,7},
      [ {2,2}, {3,3}, {4,4}, {5,4}, {6,4}, {7,4}, {8,4}, {9,4},
        {10,4}, {11,4}, {12,4}, {13,4}, {14,5}, {15,6}, {16,7},
        {17,6}, {18,7}, {19,6}, {20,7}
      ]
      |> Enum.map(fn {x,y} -> {sector,x,y} end)
    }
 
    {:ok, [env: env, well_known_path: path]}
  end


  test "well known vger path using Erlang ver", ctx do
    env = ctx[:env]
    {start, goal, res} = ctx[:well_known_path]
    assert :vger_map.astar(env, start, goal) == res
  end

  test "well known vger path using Eastar", ctx do
    env = ctx[:env]
    {start, goal, res} = ctx[:well_known_path]
    assert Astar.astar(env, start, goal) == res
 end
end
