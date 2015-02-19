defmodule Astar.HeapMap.Test do
  use ExUnit.Case
  import Astar.HeapMap

  test "new heapmap is empty" do
    assert new |> empty?
  end

  test "add + pop gives empty heap" do
    h0 = new
    {_,_,h} = h0 |> add(1,:k,:v) |> pop
    assert h |> empty?
  end

  test "pop from empty heap gives error" do
    assert_raise FunctionClauseError, fn-> 
      new |> pop
    end
  end

  test "pop gives back priority and a key" do
    assert {1,:k,_} = new |> add(1,:k,:v) |> pop
  end

  test "value is retrievable using get_by_key" do
    assert :v = new |> add(1,:k,:v) |> get_by_key(:k)
  end

  test "pop gives item with smallest priority" do
    h = new |> add(1,:k1,:v) |> add(3,:k3,:v) |> add(2,:k2,:v)
    assert {1,_,h} = h |> pop
    assert {2,_,h} = h |> pop
    assert {3,_,_} = h |> pop
  end

  test "mapping returns some internal key and a value" do
    assert {_,:v} = new |> add(1,:k,:v) |> mapping(:k)
  end

  test "mapping can be paired with delete" do
    h0 = new
    h1 = h0 |> add(1,:k1,:v)
    {tk1,_} = h1 |> mapping(:k1)
    assert ^h0 = h1 |> delete(tk1,:k1)
  end

  test "mapping can be paired with delete more than once" do
    h0 = new
    h1 = h0 |> add(1,:k1,:v)
    {tk1,_} = h1 |> mapping(:k1)
    assert ^h0 = h1 |> delete(tk1,:k1)
    h2 = h1 |> add(2,:k2,:v)
    {tk2,_} = h2 |> mapping(:k2)
    assert ^h1 = h2 |> delete(tk2,:k2)
  end
end
