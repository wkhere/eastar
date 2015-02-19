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
    {pri, key, hmap(tree: tree1, dict: dict)}
  end

  @spec mapping(t, key) :: {token | nil, val | nil}
  def mapping(hmap(dict: dict), key) do
    Dict.get(dict, key) || {nil, nil}
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
