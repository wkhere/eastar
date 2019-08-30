defmodule Astar do
  alias Astar.HeapMap
  require HeapMap.Pattern

  @moduledoc """
    A* graph pathfinding.
  """

  @type  vertex     :: any
  @type  nbs_f      :: ((vertex) -> [vertex])
  @type  distance_f :: ((vertex,vertex) -> non_neg_integer)
  @type  env        :: {nbs_f, distance_f, distance_f}


  @doc """
  Find path between two vertices in a directed weighted graph.

  * `env`   - a graph "environment" - the tuple `{nbs, dist, h}` where
    each element is a function:
    * `nbs`   - returns collection of neighbor vertices for a given vertex
    * `dist`  - returns edge cost between two neighbor vertices
    * `h`     - returns estimated cost between two arbitrary vertices
  * `start` - starting vertex
  * `goal`  - vertex we want to reach, or a function of arity 1 to check
     if current vertex is a goal
  """

  @spec astar(env, vertex, vertex) :: [vertex]

  def astar({_nbs, _dist, h}=env, start, goal) do
    openmap = HeapMap.new
              |> HeapMap.add(h.(start,goal), start, 0)

    loop(env, goal, openmap, MapSet.new, Map.new)
  end

  defp has_reached_goal?(x, goal) when is_function(goal), do: goal.(x)
  defp has_reached_goal?(x, goal), do: x == goal

  @spec loop(env, vertex, HeapMap.t, MapSet.t, Map.t) :: [vertex]

  defp loop(_, _, HeapMap.Pattern.empty, _, _), do: []

  defp loop({nbs, dist, h}=env, goal, openmap, closedset, parents) do
      {_fx, x, openmap} = HeapMap.pop(openmap)
      if has_reached_goal?(x, goal) do
        cons_path(parents, x)
      else

        closedset = MapSet.put(closedset, x)

        {openmap,parents} = Enum.reduce nbs.(x), {openmap,parents},
        fn(y, {openmap,parents}=continue) ->

          if MapSet.member?(closedset, y) do continue
          else
            est_g = HeapMap.get_by_key(openmap,x) + dist.(x,y)

            {ty, gy} = HeapMap.mapping(openmap,y)

            if gy do
              if est_g < gy do
                openmap = openmap |> HeapMap.delete(ty, y)
                update(h, x, y, goal, est_g, openmap, parents)
              else
                continue
              end
            else
              update(h, x, y, goal, est_g, openmap, parents)
            end
          end
        end

        loop(env, goal, openmap, closedset, parents)
      end
  end

  defp update(h, x, y, goal, new_gy, openmap, parents) do
    nparents = Map.put(parents, y, x)
    fy = h.(y, goal) + new_gy
    nopenmap = openmap |> HeapMap.add(fy, y, new_gy)
    {nopenmap, nparents}
  end


  @spec cons_path(Dict.t, vertex) :: [vertex]

  defp cons_path(parents, vertex), do: cons_path(parents, vertex, [])
  defp cons_path(parents, vertex, acc) do
    parent = Map.get(parents,vertex)
    if parent do
      cons_path(parents, parent, [vertex|acc])
    else acc
    end
  end
end
