# (c) 2013 Wojciech Kaczmarek
# Released under the GPLv2 license - see this for details:
# http://github.com/herenowcoder/eastar/blob/master/LICENSE

defmodule Astar.HeapMap do

  defrecordp :attr, Astar.HeapMap,
    tree: :gb_trees.empty,
    dict: HashDict.new

  def new(), do: attr()

  def empty?(self) do
    :gb_trees.size(attr(self,:tree)) == 0
  end

  def add(pri, key, val, {_mod, tree, dict}) do
    false = Dict.has_key?(dict, key)
    tree_key = {pri, make_ref}
    attr(tree: :gb_trees.insert(tree_key, key, tree), 
      dict: Dict.put(dict, key, {tree_key, val}))
  end

  def pop({_mod, tree, dict}) do
    {{pri,_ref}, key, tree1} = :gb_trees.take_smallest(tree)
    {pri, key, attr(tree: tree1, dict: Dict.delete(dict, key))}
  end

  def get_by_key(key, {_mod, _tree, dict}) do
    {_tree_key, val} = dict[key]
    val
  end

  def delete_by_key(key, {_mod, tree, dict}) do
    {tree_key, _val} = dict[key]
    attr(tree: :gb_trees.delete(tree_key, tree), 
      dict: Dict.delete(dict, key))
  end
end

defimpl Access, for: Astar.HeapMap do
  def access(self, key), do: self.get_by_key(key)
end

