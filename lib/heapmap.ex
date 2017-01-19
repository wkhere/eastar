defmodule Astar.HeapMap do

  defstruct \
    tree: :gb_trees.empty,
    dict: Map.new

  alias __MODULE__, as: H

  @opaque t       :: %H{tree: :gb_trees.tree, dict: Map.t}
  @type   pri     :: any
  @type   key     :: any
  @type   val     :: non_neg_integer
  @opaque token   :: {pri, any}

  @spec new() :: t
  def new(), do: %H{}

  @spec empty?(t) :: boolean
  def empty?(%H{tree: {0, _}}), do: true
  def empty?(%H{}), do: false

  @spec add(t, pri, key, val) :: t
  def add(%H{tree: tree, dict: dict}, pri, key, val) do
    false = Map.has_key?(dict, key)
    token = {pri, make_ref()}
    %H{tree: :gb_trees.insert(token, key, tree),
        dict: Map.put(dict, key, {token, val})}
  end

  @spec pop(t) :: {pri, key, t}
  def pop(%H{tree: tree} = self) do
    {{pri,_ref}, key, tree1} = :gb_trees.take_smallest(tree)
    {pri, key, %{self | tree: tree1}}
  end

  @spec mapping(t, key) :: {token | nil, val | nil}
  def mapping(%H{dict: dict}, key) do
    Map.get(dict, key) || {nil, nil}
  end

  @spec delete(t, token, key) :: t
  def delete(%H{tree: tree, dict: dict}, token, key) do
    %H{tree: :gb_trees.delete(token, tree),
        dict: Map.delete(dict, key)}
  end

  @spec get_by_key(t, key) :: val
  def get_by_key(%H{dict: dict}, key) do
    {_token, val} = Map.get(dict, key)
    val
  end

  defmodule Pattern do
    defmacro empty do
      quote do
        %Astar.HeapMap{tree: {0, _}}
      end
    end
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
