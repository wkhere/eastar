defmodule Astar.H.Geo.Test do
  use ExUnit.Case
  import Astar.H.Geo

  # Expected values in this testcase are taken from the web script:
  # http://www.movable-type.co.uk/scripts/latlong.html

  def prec(x, n) when n >= 1 do
    {p, ""} = :io_lib.format('~.'++[n+?0]++'f', [x]) |> to_string |> Float.parse
    p
  end
  def prec(x, 0), do: round(x)

  test "coords as degree triples" do
    assert h(
      {{50,03,59}, {05,42,53}},
      {{58,38,39}, {03,04,12}}
      ) |> prec(1) == 968.9
  end

  test "coords as decimal degrees" do
    assert h(
      {20.42,   3.5},
      {23.5,  111.111}
      ) |> prec(0) == 10780
  end

  test "distances between my example nodes" do
    import Astar.Examples.Geo.Nodes
    assert h(walcz, poznan) |> prec(1) == 102.0
    assert h(walcz, wwa)    |> prec(1) == 327.7
    assert h(poznan, wwa)   |> prec(1) == 279.2
  end
end
