defmodule Astar do
  alias Astar.HeapMap

  @type  vertex     :: any
  @type  nbs_f      :: ((vertex) -> [vertex])
  @type  distance_f :: ((vertex,vertex) -> non_neg_integer)
  @type  env        :: {nbs_f, distance_f, distance_f}


  @doc """
  A* path finding.

  * `env`   - a graph "environment" - the tuple `{nbs, dist, h}` where
    each element is a function:
    * `nbs`   - returns collection of neighbor vertices for a given vertex
    * `dist`  - returns edge cost between two neighbor vertices
    * `h`     - returns estimated cost between two arbitrary vertices
  * `start` - starting vertex
  * `goal`  - vertex we want to reach
  """

  @spec astar(env, vertex, vertex) :: [vertex]

  def astar({_nbs, _dist, h}=env, start, goal) do
    openmap = HeapMap.new
              |> HeapMap.add(h.(start,goal), start, 0)

    loop(env, goal, {openmap, HashSet.new, HashDict.new})
  end

  @spec loop(env, vertex, {HeapMap.t, Set.t, Dict.t}) :: [vertex]

  defp loop({nbs, _, _}=env, goal, {openmap, closedset, parents}) do
    if HeapMap.empty?(openmap) do []
    else
      {_fx, x, openmap} = HeapMap.pop(openmap)
      if x == goal do
        cons_path(parents, goal)
      else

        closedset = Set.put(closedset, x)

        nbs_loop(env, goal, x, nbs.(x), {openmap, closedset, parents})
      end
    end
  end

  defp nbs_loop(env, goal, _x, [], st), do:
    loop(env, goal, st)

  defp nbs_loop({_, dist, h}=env, goal, x, [y|ys], {openmap, closedset, parents}=st) do

          if Set.member?(closedset, y) do
            nbs_loop(env, goal, x, ys, st)
            # ^^ continue loop
          else
            est_g = HeapMap.get_by_key(openmap,x) + dist.(x,y)

            {ty, gy} = HeapMap.mapping(openmap,y)

            updater = fn(openmap) ->
              nparents = Dict.put(parents, y, x)
              new_gy = est_g
              fy = h.(y, goal) + new_gy
              nopenmap = openmap |> HeapMap.add(fy, y, new_gy)
              {nopenmap, closedset, nparents}
            end

            if gy do
              if est_g < gy do
                nst = updater.(openmap |> HeapMap.delete(ty, y))
                nbs_loop(env, goal, x, ys, nst)
              else
                nbs_loop(env, goal, x, ys, st)
              end
            else
              nst = updater.(openmap)
              nbs_loop(env, goal, x, ys, nst)
            end
          end

  end


  @spec cons_path(Dict.t, vertex) :: [vertex]

  defp cons_path(parents, vertex), do: cons_path(parents, vertex, [])
  defp cons_path(parents, vertex, acc) do
    parent = Dict.get(parents,vertex)
    if parent do
      cons_path(parents, parent, [vertex|acc])
    else acc
    end
  end
end
