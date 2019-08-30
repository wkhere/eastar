### v0.5.0 (2019-08-30)

* allow `goal` to be a function

### v0.4.3 (2019-08-30)

* behave on Elixir 1.8,1.9
* fix deps

### v0.4.2 (2017-01-19)

* update to Elixir 1.4.x
* test on variety of OTP/Elixir versions via travis

### v0.4.1 (2016-08-31)

* restrict to Elixir 1.2.x (typespec issues on 1.3)

### v0.4.0 (2016-04-10)

* use Map & MapSet internally instead of old Dict & Set
* above is faster by 33%
* this requires Elixir 1.2.x

### v0.3.8 (2016-01-21)

* expose pattern for empty heapmap and use it
* dev goodies: specs, bench, new reloader

### v0.3.7 (2016-01-16)

* update dev deps to nicely play with Elixir 1.2
* a tiny doc polishing

### v0.3.6 (2016-01-14)

* prepare for future full app (now just childless supervisor)
* for anyone who cares, change license to BSD

### v0.3.5 (2015-10-14)

* adapt to Elixir 1.1 and OTP 18

### v0.3.4 (2015-02-22)
* heapmap impl: switch from recordp to struct
* warmly welcoming excheck tests!

### v0.3.3 (2015-02-21)
* impl: updater moved to separate compiled fun, giving a tiny speedup
* vger tests rely on test data from upstream

### v0.3.2 (2015-02-21)
* cosmetic, tests for pathological cases, ex_doc support

### v0.3.1 (2015-02-20)
* Hex-ify

### v0.3.0 (2015-02-20)
* fix HeapMap.mapping bug
* Elixir 1.0.x
* geo tests
* vger tests
* 100% coverage

First version where A* works as expected.

### v0.2.0 (2014-08-02)
* adapt to Elixir 0.14
* cleanups, typespecs, travis, github goodies

### v0.0.1 (2014-07-02)
* experimental A* algo using reimplemented HeapMap
