defmodule Astar.H.Geo.Test do
  use ExUnit.Case
  import Astar.H.Geo

  # Expected values in this testcase are taken from the web script:
  # http://www.movable-type.co.uk/scripts/latlong.html
  # Note it displays result with a precision of 0.1 km or 1km.

  def prec1(x) do
    {p, ""} = :io_lib.format('~.1f', [x]) |> to_string |> Float.parse
    p
  end

  def prec0(x), do: round(x)

  test "coords as degree triples" do
    assert distance( 
      {{50,03,59}, {05,42,53}},
      {{58,38,39}, {03,04,12}}
      ) |> prec1 == 968.9 
  end

  test "coords as decimal degrees" do
    assert distance(
      {20.42,   3.5},
      {23.5,  111.111}
      ) |> prec0 == 10780
  end

  test "distances between my example nodes" do
    import Astar.GeoExample.Nodes
    assert distance(walcz, poznan) |> prec1 == 101.0
    assert distance(walcz, wwa)    |> prec1 == 327.0
    assert distance(poznan, wwa)   |> prec1 == 279.3
  end
end
