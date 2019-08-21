defmodule Astar.IsGoal.Test do
  use ExUnit.Case

  @nodes %{
    1 => [
      %{distance: 7.5, id: 2}
    ],
    2 => [
      %{distance: 7.5, id: 1},
      %{distance: 6.1, id: 3}
    ],
    3 => [
      %{distance: 6.1, id: 2},
      %{distance: 6.2, id: 4}
    ],
    4 => [
      %{distance: 6.2, id: 3},
      %{distance: 7.1, id: 5}
    ],
    5 => [%{distance: 7.1, id: 4}]
  }

  @goals [5, 6]

  test "using an is_goal function" do
    nbs = fn id ->
      @nodes[id]
      |> Enum.map(& &1.id)
    end

    dist = fn id1, id2 ->
      @nodes[id1]
      |> Enum.filter(&(&1.id == id2))
      |> List.first()
      |> Map.get(:distance)
    end

    h = fn id, _ -> -id end
    env = {nbs, dist, h}

    path = Astar.astar(env, 1, fn id -> Enum.member?(@goals, id) end)
    assert path == [2, 3, 4, 5]
  end
end
