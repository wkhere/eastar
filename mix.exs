defmodule Eastar.Mixfile do
  use Mix.Project

  def project do
    [ app: :eastar,
      version: "0.4.3-dev",
      package: package(),
      description: description(),
      deps: deps(),
      docs: [main: Astar],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application
  def application do
    apps = Mix.env == :dev && [:reprise] || []
    [applications: apps,
      mod: {Astar.App, []},
      description: 'A*']
  end

  defp package, do: [
    maintainers: ["Wojciech Kaczmarek"],
    licenses:     ["BSD"],
    description:  description(),
    links:        %{"GitHub" => "http://github.com/herenowcoder/eastar",
                    "HexDocs"   => "http://hexdocs.pm/eastar",
                  },
  ]

  defp description, do:
    ~S"""
    Eastar is a pure-Elixir implementation of A* graph pathfinding algorithm.

    All graph environment, like nodes connectivity, distance & H-metric
    are abstracted away - you provide them as functions.
    """

  defp deps, do: [
    {:excoveralls,  "~> 0.4.6",   only: :test},
    {:ex_doc,       "~> 0.8.0",   only: :dev},
    {:dialyze,      "== 0.2.0",   only: :dev},
    {:reprise,      "~> 0.5",     only: :dev},
    {:exprof,       "== 0.2.0",   only: :dev},
    {:excheck,      "~> 0.5.3",   only: [:dev, :test]},
    {:triq,         "~> 1.3.0",   only: [:dev, :test]},
    {:benchfella,   "== 0.3.2",   only: :dev},
    {:vger, github: "herenowcoder/vger", only: [:dev, :test]},
  ]
end
