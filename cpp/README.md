# C++

This is the code for the C++ section of the advent post.

The three code stages described in the post are:

* [cpptest.p6](cpptest.p6), [cpptest.cpp](cpptest.cpp) — naive attempt at
  calling into a C++, which doesn't work.

* [cpptest-mangled.p6](cpptest-mangled.p6), [cpptest.cpp](cpptest.cpp) —
  manually mangled calling into C++, will only work when using g++'s name
mangling.

* [cpptest-extern-c.p6](cpptest-extern-c.p6),
  [cpptest-extern-c.cpp](cpptest-extern-c.cpp) — calling into C++ using `extern
"C"`.

[IntVec.pm6](IntVec.pm6) and [intvec.cpp](intvec.cpp) contain a more involved
example of wrapping a C++ API.

There's a [Makefile](Makefile) you can use to build and test the C++ code here.
