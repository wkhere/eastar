defmodule Eastar.Mixfile do
  use Mix.Project

  def project do
    [ app: :eastar,
      version: "0.3.2",
      elixir: "~> 1.0.2",
      package: package,
      description: description,
      deps: deps,
      docs: [main: Astar],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application
  def application do
    apps = Mix.env == :dev && [:reprise] || []
    [applications: apps,
      description: 'A*']
  end

  defp package, do: [
    contributors: ["Wojciech Kaczmarek"],
    licenses:     ["GPLv2"],
    description:  description,
    links:        %{"GitHub" => "http://github.com/herenowcoder/eastar"},
  ]

  defp description, do:
    ~S"""
    Eastar is a pure-Elixir implementation of A* graph pathfinding algorithm.

    All graph environment, like nodes connectivity, distance & H-metric
    are abstracted away - you provide them as functions.
    """

  defp deps, do: [
    {:excoveralls,  "== 0.3.6",   only: :test},
    {:ex_doc,       "~> 0.7.1",   only: :dev},
    {:dialyze,      "== 0.1.3",   only: :dev},
    {:reprise,      "== 0.3.0",   only: :dev},
    {:exprof,       "== 0.2.0",   only: :dev},
    {:vger, github: "herenowcoder/vger", only: [:dev, :test]},
  ]
end
