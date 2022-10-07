defmodule Astar.HeapMap.ExCheck.Test do
  use ExUnit.Case
  use ExCheck
  import Astar.HeapMap

  property "add makes value retrievable by get_by_key and mapping" do
    h0 = new()
    for_all {pri, k, v} in {int(), any(), any()} do
      h = h0 |> add(pri, k, v)
      h |> get_by_key(k) == v and
      h |> mapping(k) |> elem(1) == v
    end
  end

  property "pop gives item with smallest priority [2 items]" do
    h0 = new()
    for_all {pri1, pri2, k1, k2, v} in
      such_that({_, _, k1, k2, _} in {int(), int(), any(), any(), any()}
        when k1 !== k2)
    do
      implies pri1 < pri2 do
        h = h0 |> add(pri1, k1, v) |> add(pri2, k2, v)
        {pri, k, _} = h |> pop
        pri == pri1 and k == k1
      end
    end
  end

  property "pop gives item with smallest priority [N items]" do
    h0 = new()
    for_all l in list(int()) do
      implies l != [] do
        pmin = Enum.min(l)
        h = for i <- l, into: h0, do: {i, make_ref(), :v}
        {p, _, _} = h |> pop
        p == pmin
      end
    end
  end

  property "pop leaves mapping intact" do
    h0 = new()
    for_all {p1, p2, p3,  k1, k2, k3,  v1, v2, v3} in
      such_that({_, _, _,  k1, k2, k3,  _, _, _} 
        in {int(), int(), int(),  any(), any(), any(),  any(), any(), any()}
        when k1 !== k2 and k2 !== k3 and k1 !== k3)
    do
      h = h0 |> add(p1,k1,v1) |> add(p2,k2,v2) |> add(p3,k3,v3)
          |> pop |> elem(2) |> pop |> elem(2) |> pop |> elem(2)
      h |> get_by_key(k1) == v1 and
      h |> get_by_key(k2) == v2 and
      h |> get_by_key(k3) == v3
    end
  end

end
