defmodule Astar.HeapMap do

  defstruct \
    tree: :gb_trees.empty,
    dict: HashDict.new

  @h __MODULE__

  @opaque t       :: %@h{tree: :gb_trees.tree, dict: Dict.t}
  @type   pri     :: any
  @type   key     :: any
  @type   val     :: non_neg_integer
  @opaque token   :: {pri, any}

  @spec new() :: t
  def new(), do: %@h{}

  @spec empty?(t) :: boolean
  def empty?(%@h{tree: tree}) do
    :gb_trees.size(tree) == 0
  end

  @spec add(t, pri, key, val) :: t
  def add(%@h{tree: tree, dict: dict}, pri, key, val) do
    false = Dict.has_key?(dict, key)
    token = {pri, make_ref}
    %@h{tree: :gb_trees.insert(token, key, tree),
        dict: Dict.put(dict, key, {token, val})}
  end

  @spec pop(t) :: {pri, key, t}
  def pop(%@h{tree: tree} = self) do
    {{pri,_ref}, key, tree1} = :gb_trees.take_smallest(tree)
    {pri, key, %{self | tree: tree1}}
  end

  @spec mapping(t, key) :: {token | nil, val | nil}
  def mapping(%@h{dict: dict}, key) do
    Dict.get(dict, key) || {nil, nil}
  end

  @spec delete(t, token, key) :: t
  def delete(%@h{tree: tree, dict: dict}, token, key) do
    %@h{tree: :gb_trees.delete(token, tree),
        dict: Dict.delete(dict, key)}
  end

  @spec get_by_key(t, key) :: val
  def get_by_key(%@h{dict: dict}, key) do
    {_token, val} = Dict.get(dict, key)
    val
  end
end


defimpl Collectable, for: Astar.HeapMap do
  def into(original) do
    {original, fn
      h, {:cont, {p, k, v}} -> h |> Astar.HeapMap.add(p, k, v)
      h, :done -> h
      _, :halt -> :ok
    end}
  end
end
