defmodule Astar.Utils.H.Geo do
  @moduledoc """
  Exposes H-function as a shortest distance between
  two points on Earth globe, plus a number of conversion
  functions.
  """

  import :math

  @pi_by_180    pi()/180
  @earth_radius 6371


  def to_deg({deg, min, sec}), do:
    deg + min/60 + sec/3600
  def to_deg(a) when is_number(a), do: a

  def to_radian(a), do:
    (a |> to_deg) * @pi_by_180


  def h({lat1, lon1}, {lat2, lon2}) do
    phi1 = lat1 |> to_radian
    phi2 = lat2 |> to_radian
    dphi = ((lat2 |> to_deg) - (lat1 |> to_deg)) |> to_radian
    dl   = ((lon2 |> to_deg) - (lon1 |> to_deg)) |> to_radian

    sp = sin(dphi/2)
    sl = sin(dl/2)
    a = sp*sp + cos(phi1)*cos(phi2)*sl*sl
    c = 2*atan2(sqrt(a), sqrt(1-a))
    @earth_radius * c
  end
end
