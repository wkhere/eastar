defmodule Astar.HeapMapTest do
  use ExUnit.Case

  test "new heapmap is empty" do
    assert Astar.HeapMap.new.empty?
  end

  test "add + pop gives empty heap" do
    h0 = Astar.HeapMap.new
    assert {_,_,h0} = h0.add(1,:k,:v).pop
  end

  test "pop from empty heap gives error" do
    assert_raise FunctionClauseError, fn-> 
      Astar.HeapMap.new.pop
    end
  end

  test "pop gives back priority and a key" do
    assert {1,:k,_} = Astar.HeapMap.new.add(1,:k,:v).pop
  end

  test "value is retrievable using get_by_key" do
    assert :v = Astar.HeapMap.new.add(1,:k,:v).get_by_key(:k)
  end

  test "value is retrievable using Access protocol" do
    assert :v = Astar.HeapMap.new.add(1,:k,:v)[:k]
  end

  test "pop gives item with smallest priority" do
    h = Astar.HeapMap.new.add(1,:k1,:v).add(3,:k3,:v).add(2,:k2,:v)
    assert {1,_,h} = h.pop
    assert {2,_,h} = h.pop
    assert {3,_,_} = h.pop
  end
end
