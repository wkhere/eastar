defmodule Astar.GeoExample.Test do
  use ExUnit.Case
  import Astar
  import Astar.GeoExample

  test "empty path" do
    for n <- all_nodes, do: 
      assert astar(env, n, n) == []
  end

  test "path of len=1" do
    assert astar(env, :walcz, :wwa) == [:wwa]
  end
end
