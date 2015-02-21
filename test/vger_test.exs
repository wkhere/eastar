defmodule Astar.Vger.Test do
  use ExUnit.Case

  setup do
    :vger_map.setup
    {:ok, [params: :vger_map.well_known_path]}
  end


  test "well known vger path using Erlang ver", ctx do
    {env, start, goal, res} = ctx[:params]
    assert :vger_map.astar(env, start, goal) == res
  end

  test "well known vger path using Eastar", ctx do
    {env, start, goal, res} = ctx[:params]
    assert Astar.astar(env, start, goal) == res
 end
end
