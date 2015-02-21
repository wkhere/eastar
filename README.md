eastar
======

[![Build Status](https://travis-ci.org/herenowcoder/eastar.svg)](https://travis-ci.org/herenowcoder/eastar)
[![Coverage Status](https://img.shields.io/coveralls/herenowcoder/eastar.svg)](https://coveralls.io/r/herenowcoder/eastar)
[![hex.pm version](https://img.shields.io/hexpm/v/eastar.svg)](https://hex.pm/packages/eastar)
[![hex.pm license](https://img.shields.io/hexpm/l/eastar.svg)](https://github.com/herenowcoder/eastar/raw/master/LICENSE)


Pure Elixir implementation of [A\*] graph pathfinding.

This version aims to be as generic as possible, abstracting away
the graph environment: nodes connectivity, distance & H-metric -
you provide them as functions.

If you like some references to the literature,
you can think of it as the *star of Ea*.


[A\*]:      http://en.wikipedia.org/wiki/A*_search_algorithm
