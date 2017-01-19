eastar
======

[![Build Status](https://travis-ci.org/wkhere/eastar.svg?branch=master)](https://travis-ci.org/wkhere/eastar)
[![Coverage Status](https://coveralls.io/repos/github/wkhere/eastar/badge.svg?branch=master)](https://coveralls.io/github/wkhere/eastar?branch=master)
[![hex.pm version](https://img.shields.io/hexpm/v/eastar.svg)](https://hex.pm/packages/eastar)


Pure Elixir implementation of [A\*] graph pathfinding.

This version aims to be as generic as possible, abstracting away
the graph environment: nodes connectivity, distance & H-metric -
you provide them as functions.

If you like some references to the literature,
you can think of it as the *star of Ea*.

### usage

API is described at [hexdocs](http://hexdocs.pm/eastar/).

Look at examples and tests to see how graph environment can be set up.

Enjoy!

[A\*]:      http://en.wikipedia.org/wiki/A*_search_algorithm
