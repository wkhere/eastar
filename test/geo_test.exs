defmodule Astar.H.Geo.Test do
  use ExUnit.Case
  import Astar.H.Geo

  def prec1(x) do
    {p, ""} = :io_lib.format('~.1f', [x]) |> to_string |> Float.parse
    p
  end

  test "some distances from a web script" do
    # see http://www.movable-type.co.uk/scripts/latlong.html

    assert distance( 
      {{50,03,59}, {05,42,53}},
      {{58,38,39}, {03,04,12}}
      ) |> prec1 == 968.9 

    import Astar.GeoExample
    assert distance(walcz, poznan) |> prec1 == 101.0
    assert distance(walcz, wwa)    |> prec1 == 327.0
    assert distance(poznan, wwa)   |> prec1 == 279.3
  end
end