# (c) 2013,2014 Wojciech Kaczmarek
# Released under the GPLv2 license - see this for details:
# http://github.com/herenowcoder/eastar/blob/master/LICENSE

defmodule Astar.HeapMap do
  import Record

  defrecordp :hmap,
    tree: :gb_trees.empty,
    dict: HashDict.new

  @opaque t       :: record(:hmap, tree: :gb_trees.tree, dict: Dict.t)
  @type   pri     :: any
  @type   key     :: any
  @type   val     :: non_neg_integer
  @opaque token   :: {pri, any}

  @spec new() :: t
  def new(), do: hmap()

  @spec empty?(t) :: boolean
  def empty?(self) do
    :gb_trees.size(hmap(self,:tree)) == 0
  end

  @spec add(t, pri, key, val) :: t
  def add(hmap(tree: tree, dict: dict), pri, key, val) do
    false = Dict.has_key?(dict, key)
    token = {pri, make_ref}
    hmap(tree: :gb_trees.insert(token, key, tree),
      dict: Dict.put(dict, key, {token, val}))
  end

  @spec pop(t) :: {pri, key, t}
  def pop(hmap(tree: tree, dict: dict)) do
    {{pri,_ref}, key, tree1} = :gb_trees.take_smallest(tree)
    {pri, key, hmap(tree: tree1, dict: Dict.delete(dict, key))}
  end

  @spec mapping(t, key) :: {token | nil, val | nil}
  def mapping(hmap(dict: dict), key) do
    res = {_token, val} = Dict.get(dict, key)
    if val==nil, do: {nil, nil}, else: res
  end

  @spec delete(t, token, key) :: t
  def delete(hmap(tree: tree, dict: dict), token, key) do
    hmap(tree: :gb_trees.delete(token, tree),
      dict: Dict.delete(dict, key))
  end

  @spec get_by_key(t, key) :: val
  def get_by_key(hmap(dict: dict), key) do
    {_token, val} = Dict.get(dict, key)
    val
  end
end


defmodule Astar do
  require Astar.HeapMap, [as: HMap]

  @type  vertex     :: any
  @type  distance_f :: ((vertex,vertex) -> non_neg_integer)
  @type  env        :: {distance_f, [vertex], distance_f}

  @spec astar(env, vertex, vertex) :: [vertex]

  def astar({h, _nbs, _dist}=env, node0, goal) do
    openmap = HMap.new
              |> HMap.add(h.(node0,goal), node0, 0)

    loop(env, goal, openmap, HashSet.new, HashDict.new)
  end


  @spec loop(env, vertex, HMap.t, Set.t, Dict.t) :: [vertex]

  defp loop({h, nbs, dist}=env, goal, openmap, closedset, parents) do
    if HMap.empty?(openmap) do []
    else
      {_fx, x, openmap} = HMap.pop(openmap)
      if x == goal do
        cons_path(parents, goal)
      else

        closedset = Set.put(closedset, x)

        {openmap,parents} = Enum.reduce nbs.(x), {openmap,parents},
        fn(y, {openmap,parents}=continue) ->

          if Set.member?(closedset, y) do continue
          else
            est_g = HMap.get_by_key(openmap,x) + dist.(x,y)

            {ty, gy} = HMap.mapping(openmap,y)

            updater = fn(openmap) ->
              nparents = Dict.put(parents, y, x)
              new_gy = est_g
              fy = h.(y, goal) + new_gy
              nopenmap = openmap |> HMap.add(fy, y, new_gy)
              {nopenmap, nparents}
            end

            if gy do
              if est_g < gy do
                updater.(openmap |> HMap.delete(ty, y))
              else
                continue
              end
            else
              updater.(openmap)
            end
          end
        end

        loop(env, goal, openmap, closedset, parents)
      end
    end
  end


  @spec cons_path(Dict.t, vertex) :: [vertex]

  defp cons_path(parents, node), do: cons_path(parents, node, [])
  defp cons_path(parents, node, acc) do
    parent = Dict.get(parents,node)
    if parent do
      cons_path(parents, parent, [node|acc])
    else acc
    end
  end
end
