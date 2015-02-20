defmodule Eastar.Mixfile do
  use Mix.Project

  def project do
    [ app: :eastar,
      version: "0.3.1-dev",
      elixir: "~> 1.0.2",
      package: package,
      description: description,
      deps: deps,
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

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps, do: [
    {:excoveralls, "== 0.3.6",  only: :test},
    {:dialyze,     "== 0.1.3",  only: :dev},
    {:reprise,     "== 0.3.0",  only: :dev},
    {:vger,   github: "herenowcoder/vger", only: [:dev, :test]},
  ]
end
