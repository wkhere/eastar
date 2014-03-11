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

  def get_by_key(key, hmap(dict: dict)) do
    {_tree_key, val} = dict[key]
    val
  end

  def delete_by_key(key, hmap(tree: tree, dict: dict)) do
    {tree_key, _val} = dict[key]
    hmap(tree: :gb_trees.delete(tree_key, tree),
      dict: Dict.delete(dict, key))
  end
end

defimpl Access, for: Astar.HeapMap do
  def access(self, key), do: self.get_by_key(key)
end


defmodule Astar do

  def astar({h, nbs, dist}, node0, goal) do
    closedset = HashSet.new
    parents = HashDict.new
    g0 = 0
    f0 = h.(node, goal)
    open = Astar.HeapMap.new
    open = Astar.HeapMap.add open, f0, node0, g0
    # to be translated yet...
    # loop exit - via throw/catch
  end

  defp cons_path(parents, node) do
    if (parent = parents[node]), 
    do: cons_path(parents, parent) ++ [node], else: []  
  end

end
