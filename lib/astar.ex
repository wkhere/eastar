# (c) 2013 Wojciech Kaczmarek
# Released under the GPLv2 license - see this for details:
# http://github.com/herenowcoder/eastar/blob/master/LICENSE

defmodule Astar.HeapMap do

  defrecordp :hmap, Astar.HeapMap,
    tree: :gb_trees.empty,
    dict: HashDict.new

  def new(), do: hmap()

  def empty?(self) do
    :gb_trees.size(hmap(self,:tree)) == 0
  end

  def add(pri, key, val, hmap(tree: tree, dict: dict)) do
    false = Dict.has_key?(dict, key)
    tree_key = {pri, make_ref}
    hmap(tree: :gb_trees.insert(tree_key, key, tree),
      dict: Dict.put(dict, key, {tree_key, val}))
  end

  def pop(hmap(tree: tree, dict: dict)) do
    {{pri,_ref}, key, tree1} = :gb_trees.take_smallest(tree)
    {pri, key, hmap(tree: tree1, dict: Dict.delete(dict, key))}
  end

  def mapping(key, hmap(dict: dict)) do
    {_tree_key, _val} = Dict.get(dict, key)
  end

  def delete(tree_key, key, hmap(tree: tree, dict: dict)) do
    hmap(tree: :gb_trees.delete(tree_key, tree),
      dict: Dict.delete(dict, key))
  end

  def get_by_key(key, hmap(dict: dict)) do
    {_tree_key, val} = Dict.get(dict, key)
    val
  end
end

defimpl Access, for: Astar.HeapMap do
  def access(self, key), do: self.get_by_key(key)
end


defmodule Astar do

  def astar({h, _nbs, _dist}=env, node0, goal) do
    openmap = Astar.HeapMap.new.add(h.(node0,goal), node0, 0)

    loop(env, goal, openmap, HashSet.new, HashDict.new)
  end

  defp loop({h, nbs, dist}=env, goal, openmap, closedset, parents) do
    if openmap.is_empty? do []
    else
      {_fx, x, openmap} = openmap.pop
      if x == goal do
        cons_path(parents, goal)
      else

        closedset = Set.put(closedset, x)

        {openmap,parents} = Enum.reduce nbs.(x), {openmap,parents},
        fn(y, {openmap,parents}=continue) ->

          if Set.member?(closedset, y) do continue
          else
            est_g = openmap[x] + dist.(x,y)

            {ty, gy} = openmap.mapping(y)

            updater = fn(openmap) ->
              nparents = Dict.put(parents, y, x)
              new_gy = est_g
              fy = h.(y, goal) + new_gy
              nopenmap = openmap.add(fy, y, new_gy)
              {nopenmap, nparents}
            end

            if gy do
              if est_g < gy do
                updater.(openmap.delete(ty, y))
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

  defp cons_path(parents, node), do: cons_path(parents, node, [])
  defp cons_path(parents, node, acc) do
    parent = Dict.get(parents,node)
    if parent do
      cons_path(parents, parent, [node|acc])
    else acc
    end
  end
end
