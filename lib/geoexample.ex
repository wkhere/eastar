defmodule Astar.GeoExample do

  defmodule Nodes do
    def walcz,    do: {53.283853, 16.470173}
    def poznan,   do: {52.408031, 16.920613}
    def wwa,      do: {52.230069, 21.018513}
  end

  defp coords(node), do: apply(Nodes, node, [])

  def all_nodes, do: Nodes.__info__(:functions) |> Keyword.keys

  def nbs(_node), do: all_nodes


  def dist(node1, node2) # arbitrary distances - road kms or some foo

  def dist(:walcz,   :poznan),  do: 119
  def dist(:walcz,   :wwa),     do: 421
  def dist(:poznan,  :wwa),     do: 310

  def dist(n1, n2), do: dist(n2, n1)


  def h(node1, node2), do:
    Astar.H.Geo.h(coords(node1), coords(node2))


  def env(), do:
    {&__MODULE__.nbs/1, &__MODULE__.dist/2, &__MODULE__.h/2}
end
