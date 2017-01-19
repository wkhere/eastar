defmodule Astar.Geo.Test do
  use ExUnit.Case
  import Astar
  import Astar.Examples.Geo

  test "empty path" do
    for n <- all_nodes(), do: 
      assert astar(env(), n, n) == []
  end

  test "path of len=1" do
    assert astar(env(), :walcz, :wwa)    == [:wwa]
    assert astar(env(), :wwa,   :walcz)  == [:walcz]
  end
end
